Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 22:28:30 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605182830.GB5789@albatros>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oLBj+sq0vYjzfsbl"
Content-Disposition: inline
Subject: [kernel-hardening] [RFC v1] debugfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--oLBj+sq0vYjzfsbl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch adds support of 2 debugfs mount options:

umask=3D0XXX - umask for newly created debugfs files.

gid=3DYYY - gid for newly created debugfs files.

While implementing it, I realized that it is probably more usefull to
implement it as 2 sysctls and CONFIG_DEBUGFS_* options - a lot of
debugfs files are created at the boot time, so it makes sense to change
these setting at the compile time and not to bother with chmod'ing
already created files.

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index d38c88f..5af9658 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -21,8 +21,10 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/debugfs.h>
+#include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/string.h>
+#include <linux/seq_file.h>
 #include <linux/magic.h>
 #include <linux/slab.h>
=20
@@ -30,6 +32,9 @@ static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
 static bool debugfs_registered;
=20
+unsigned int debugfs_umask;
+gid_t debugfs_gid;
+
 static struct inode *debugfs_get_inode(struct super_block *sb, int mode, d=
ev_t dev,
 				       void *data, const struct file_operations *fops)
=20
@@ -63,8 +68,10 @@ static struct inode *debugfs_get_inode(struct super_bloc=
k *sb, int mode, dev_t d
 			inc_nlink(inode);
 			break;
 		}
+		inode->i_mode &=3D ~(0777 & debugfs_umask);
+		inode->i_gid =3D debugfs_gid;
 	}
-	return inode;=20
+	return inode;
 }
=20
 /* SMP-safe */
@@ -125,11 +132,85 @@ static inline int debugfs_positive(struct dentry *den=
try)
 	return dentry->d_inode && !d_unhashed(dentry);
 }
=20
+enum {
+	Opt_gid, Opt_umask, Opt_err
+};
+
+static const match_table_t debug_tokens =3D {
+	{Opt_gid, "gid=3D%u"},
+	{Opt_umask, "umask=3D%o"},
+	{Opt_err, NULL},
+};
+
+static int debug_parse_options(char *options, struct super_block *sb)
+{
+	char *p;
+	substring_t args[MAX_OPT_ARGS];
+	int option;
+
+	if (!options)
+		return 1;
+
+	while ((p =3D strsep(&options, ",")) !=3D NULL) {
+		int token;
+		if (!*p)
+			continue;
+
+		token =3D match_token(p, debug_tokens, args);
+		switch (token) {
+		case Opt_gid:
+			if (match_int(&args[0], &option))
+				return 0;
+			debugfs_gid =3D option;
+			break;
+		case Opt_umask:
+			if (match_octal(&args[0], &option))
+				return 0;
+			debugfs_umask =3D option;
+			break;
+		default:
+			pr_err("debugfs: unrecognized mount option \"%s\" "
+			       "or missing value", p);
+			return 0;
+		}
+	}
+	return 1;
+}
+
+static int debug_remount_fs(struct super_block *sb, int *flags, char *opti=
ons)
+{
+	if (debug_parse_options(options, sb))
+		return 0;
+	else
+		return -EINVAL;
+}
+
+int debug_show_options(struct seq_file *seq, struct vfsmount *vfs)
+{
+	if (debugfs_umask)
+		seq_printf(seq, ",umask=3D%o", debugfs_umask);
+	if (debugfs_gid)
+		seq_printf(seq, ",gid=3D%lu", (unsigned long)debugfs_gid);
+	return 0;
+}
+
+static const struct super_operations debug_super_operations =3D {
+	.statfs		=3D simple_statfs,
+	.remount_fs	=3D debug_remount_fs,
+	.show_options   =3D debug_show_options,
+};
+
 static int debug_fill_super(struct super_block *sb, void *data, int silent)
 {
 	static struct tree_descr debug_files[] =3D {{""}};
+	int err;
+
+	if (!debug_parse_options(data, sb))
+		return -EINVAL;
=20
-	return simple_fill_super(sb, DEBUGFS_MAGIC, debug_files);
+	sb->s_op =3D &debug_super_operations;
+	err =3D simple_fill_super(sb, DEBUGFS_MAGIC, debug_files);
+	return err;
 }
=20
 static struct dentry *debug_mount(struct file_system_type *fs_type,
--

--oLBj+sq0vYjzfsbl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN68rOAAoJEBoUx9gkVaZcVM8P/1ZecMN3wzX2Dtw+C+1rFwSY
6uR+8b5QReR7E4pkaPV5AjBfmKtojosjKx0/4hoAfqn7zcipBzK/VDwqcUzTdjrm
IBtUmOY0CmuYIcbpGf++T/c/Gxfa7OZezJc+MicVGxA7Z/6cOzOTuK6uuBPLT8KR
rzutIOdgHXqePt2NiSJvWUapYvf0gCZOHNaVVbUMnXmQpRqKLx86NIihmD84mwGt
/S5fMmpPA6u5WgwitQYVD3RRXeRMZwDx/ogOm3jsRXbewHkpR+fsCSHvCpcqBMif
al7zq9PBBuhUMJ4WW6LYSfkA8wxDjUVy62qi8NKHU1BgMtUtS/oDrrJiJQM5j/+2
D9yC64L6LIdEAmp2OQRPVF6bYtHD26FELLvnGmNo4TpsFgim11nk4O+cIEHNK5c1
20GiqjRySFVlUWqBCZyUWq4oM+sDLhH5zkhwpobu+hiJQz3CbdnNJLybEk9cLNTY
GX14lXXCqzLmxsVADDdxD9FNCCqBNPimQ5yqXMIkpbLyjEtj7uwL+6kezNPBe2tf
3NOTQaBjfNgEfpm343m2/V7ZZqhNy9/5vqyBnTeOb4Xz8Mbudd33k0IOjuG2HnOB
b28pzZd3io4snZf7QNT3fxqy3o516H1zckR4StkoLqbCAnyxQHAAwNq+2wKolqG/
mbLnyRubfa9gldyGts/z
=8bmd
-----END PGP SIGNATURE-----

--oLBj+sq0vYjzfsbl--
