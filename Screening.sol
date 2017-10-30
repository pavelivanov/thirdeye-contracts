pragma solidity ^0.4.0;

contract Ownable {

  address public owner;

  function Ownable() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }
}

contract ScreeningFactory {

  address[] public screenings;
  mapping (address => uint32[]) public ownerScreenings;

  function createScreening (
  string title,
  bytes32 fileHash,
  bytes32 agendaHash,
  bytes32 descriptionHash,
  uint16 minorReward,
  uint16 majorReward,
  uint16 criticalReward
  ) payable
  {
    address screening = new Screening(
    msg.sender,
    title,
    fileHash,
    agendaHash,
    descriptionHash,
    minorReward,
    majorReward,
    criticalReward
    );

    screenings.push(screening);
    ownerScreenings[msg.sender].push(screenings.length - 1);
  }
}

contract Screening is Ownable {

  struct Rewards {
  uint16 minorReward;
  uint16 majorReward;
  uint16 criticalReward;
  }

  string title;

  bytes32 fileHash;
  bytes32 agendaHash;
  bytes32 descriptionHash;

  address owner;
  address[] openClaims;

  Rewards rewards;

  bool screeningActive;

  modifier notOpenClaims() {

  }

  modifier onlyClaim() {

  }

  function Screening(
  string _title,
  bytes32 _fileHash,
  bytes32 _agendaHash,
  bytes32 _descriptionHash,
  uint16 _minorReward,
  uint16 _majorReward,
  uint16 _criticalReward) payable
  {
    owner = msg.sender;
    title = _title;
    fileHash = _fileHash;
    agendaHash = _agendaHash;
    descriptionHash =_descriptionHash;
    rewards.minorReward = _minorReward;
    rewards.majorReward = _majorReward;
    rewards.criticalReward = _criticalReward;
    screeningActive = true;
  }

  function pauseScreening() onlyOwner {
    screeningActive = false;
  }

  function startScreening() onlyOwner {
    screeningActive = true;
  }

  function closeScreening() onlyOwner notOpenClaims {
    screeningActive = false;
    owner.transfer(this.balance);
  }

  function public createClaim() {
    _;
    // open
  }

  function rewardReviewer(address reviewer, uint value) onlyClaim returns(bool) {
    reviewer.transfer(value);
    return true;
  }

}
