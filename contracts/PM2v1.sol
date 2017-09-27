pragma solidity ^0.4.13;

contract SafeMath {
	
    function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
        assert((z = x - y) <= x);
    }

    function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
        assert((z = x + y) >= x);
    }
	
	function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
        z = x / y;
    }
	
	function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
        z = x <= y ? x : y;
    }
}

contract Owned {
    address public owner;
    address public newOwner;
    event OwnershipTransferred(address indexed _from, address indexed _to);

    function Owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        assert (msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
 
    function acceptOwnership() public {
        if (msg.sender == newOwner) {
            OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        }
    }
}

contract Developer{
	event RegistrationDeveloper(address indexed developer, uint info);	
	struct _Developer {
		bool confirmation;
		uint info;
		uint8 status;
	}
	
	struct Vote {
        uint vote; 
		bool voted; 
    }
	
	mapping (address => _Developer) public developers;
	mapping (address => mapping (address => Vote)) public votesDeveloper;
	
	function registrationDeveloper (uint _info) public {
		developers[msg.sender]=_Developer({
			confirmation: false,
			info: _info,
			status: 1
		});
		RegistrationDeveloper(msg.sender,_info);	
	}
	
	function voting(address _developer,uint vote) public {
		assert(vote<=5);
		Vote storage sender = votesDeveloper[_developer][msg.sender];
        assert(!sender.voted);
        sender.voted = true;
		sender.vote=vote;
	}
	
}

contract Application is Developer,SafeMath{
	event RegistrationApplication(uint8 category, uint countAppOfCategory, bool free, uint256 value, address indexed developer, string nameApp, string hashIpfs);
	event changeHashIpfsEvent(uint8 category, uint idApp, string hashIpfs);
	struct _Application {
		uint8 status;
		uint8 category;
		bool free;
		bool confirmation;
		uint256 value;
		address developer;
		string nameApp; 
		string hashIpfs;
	}
	
	mapping (uint => uint) public countAppOfCategory; 
	mapping (uint => mapping (uint => _Application)) public applications;
	function registrationApplication (uint8 _category, bool _free,uint256 _value, string _nameApp, string _hashIpfs) public {
		assert(developers[msg.sender].confirmation==true);
		countAppOfCategory[_category] = add(countAppOfCategory[_category],1); 
		applications[_category][countAppOfCategory[_category]]=_Application({
			status: 1,
			category: _category,
			free: _free,
			confirmation: false,
			value: _value,
			developer: msg.sender,
			nameApp: _nameApp,
			hashIpfs: _hashIpfs
		});
		RegistrationApplication(_category, countAppOfCategory[_category], _free, _value, msg.sender, _nameApp, _hashIpfs );
	}
	
	function changeHashIpfs(uint _idApp, uint8 _category, string _hashIpfs) public {
		assert(developers[msg.sender].confirmation==true);
		assert(applications[_category][_idApp].confirmation==true);
		applications[_category][_idApp].hashIpfs =_hashIpfs;
		changeHashIpfsEvent(_category, _idApp, _hashIpfs);
	}
}

contract User is Application{
	event RegistrationUser(address indexed user, uint info);	
	struct _User {
		uint8 status;
		bool confirmation;
		uint info;
	}
	
	struct Purchase {
		bool confirmation;
	}
	uint256 public commission;
	mapping (address => uint256) public developerRevenue;
	mapping (address => _User) public users;
	mapping (address => mapping (uint =>  mapping (uint => Purchase))) public purchases;
	function registrationUser (uint _info) public {
		users[msg.sender] = _User({
			status: 1,
			confirmation: false,
			info: _info
		});
		RegistrationUser(msg.sender,_info);	
	}
	
	function buyApp (uint _idApp, uint _category) public payable {
		assert(applications[_category][_idApp].value == msg.value);
		//assert(users[_user].status>0 && users[_user].status<=1);
		purchases[msg.sender][_category][_idApp].confirmation = true;
		uint sum = sub(msg.value,div(msg.value,10));
		developerRevenue[applications[_category][_idApp].developer] = add(developerRevenue[applications[_category][_idApp].developer],sum);
		commission = add(commission,sub(msg.value,sum));
	}
}

contract PlayMarket is User,Owned{

	function confirmationDeveloper(address _developer, bool _value) public onlyOwner {
		assert(developers[_developer].status>0 && developers[_developer].status<=1);
		developers[_developer].confirmation = _value;
	}

	function confirmationApplication(uint _application,uint _category, bool _value) public onlyOwner{
		assert(applications[_category][_application].status>0 && applications[_category][_application].status<=1);
		applications[_category][_application].confirmation = _value;
	}
	
	function confirmationUser(address _user, bool _value) public onlyOwner{
		assert(users[_user].status>0 && users[_user].status<=1);
		users[_user].confirmation = _value;
	}
	
	function collect() public onlyOwner {
		owner.transfer(commission);
	}
	
	function collectDeveloper() public {
		msg.sender.transfer(developerRevenue[msg.sender]);
	}
}
