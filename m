From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH] net: dsa: drop some VLAs in switch.c
Date: Tue, 13 Mar 2018 20:50:47 +0100
Message-Id: <1520970647-19587-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Vivien Didelot <vivien.didelot@savoirfairelinux.com>
List-ID: <kernel-hardening.lists.openwall.com>

dsa_switch's num_ports is currently fixed to DSA_MAX_PORTS. So we avoid
2 VLAs[1] by using DSA_MAX_PORTS instead of ds->num_ports.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 net/dsa/switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index b935117..78e9897 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -136,7 +136,7 @@ static int dsa_switch_mdb_add(struct dsa_switch *ds,
 {
 	const struct switchdev_obj_port_mdb *mdb = info->mdb;
 	struct switchdev_trans *trans = info->trans;
-	DECLARE_BITMAP(group, ds->num_ports);
+	DECLARE_BITMAP(group, DSA_MAX_PORTS);
 	int port;
 
 	/* Build a mask of Multicast group members */
@@ -204,7 +204,7 @@ static int dsa_switch_vlan_add(struct dsa_switch *ds,
 {
 	const struct switchdev_obj_port_vlan *vlan = info->vlan;
 	struct switchdev_trans *trans = info->trans;
-	DECLARE_BITMAP(members, ds->num_ports);
+	DECLARE_BITMAP(members, DSA_MAX_PORTS);
 	int port;
 
 	/* Build a mask of VLAN members */
-- 
1.9.1
