class SavedConnection {
  final String name;
  final String supernode;
  final String community;
  final String communityKey;
  final String selfAddress;

  SavedConnection(this.name, this.supernode, this.community, this.communityKey,
      this.selfAddress);

  factory SavedConnection.fromJson(Map<String, dynamic> json) =>
      SavedConnection(
        json['name'] as String,
        json['supernode'] as String,
        json['community'] as String,
        json['communityKey'] as String,
        json['selfAddress'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'supernode': supernode,
        'community': community,
        'communityKey': communityKey,
        'selfAddress': selfAddress,
      };
}
