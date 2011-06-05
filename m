Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 5 Jun 2011 23:47:46 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110605194746.GA6484@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20110605192641.GA9240@openwall.com>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Solar,

On Sun, Jun 05, 2011 at 23:26 +0400, Solar Designer wrote:
> On Sun, Jun 05, 2011 at 10:24:31PM +0400, Vasiliy Kulikov wrote:
> > This patch introduces support of procfs mount options and adds mount
> > options to restrict access to /proc/PID/ directories and /proc/PID/net/
> > contents.  The default backward-compatible behaviour is left untouched.
> >=20
> > The first mount option is called "hidepid" and its value defines how mu=
ch
> > info about processes we want to be available for non-owners:
> >=20
> > hidepid=3D0 (default) means the current behaviour - anybody may read all
> > /proc/PID/* files.
>=20
> Aren't some /prod/PID/* files restricted by default, in stock kernels?
> I think several are (auxv, fd/, mem).  So perhaps re-word this.

Yes, I've mentioned still accessible files in hidepid=3D1.  Will do.

> > hidepid=3D1 means all files not running as current user and group are
>=20
> "... files not running ..." needs to be re-worded.

Oops, made a mistake while rewording.

> > TODO/thoughs:
> >   - /proc/pid/net/ currently doesn't show ANYTHING, even "." and "..".
> >     This is confusing :)
>=20
> Ouch.  Can't you simply restrict its perms such that this directory
> can't be listed unless you have privs?

Well, yes, but it would touch too many code - currently it is handled as
an entry in a static table.  Changing this would touch many high level
loops of the table handling.  Hiding its contents is just simplier.

Another solution - create a fake net namespace and process this
namespace if not enough permissions :)  It also removes weird netstat
errors like "seems like networking was disabled for this kernel".

>  It should act as a normal mode
> 550 directory on a regular filesystem.

What 550 perms would give?  /proc/pid/net/ contains all network
information about _all_ network connections in current net namespace.
So, /proc/1/net and /proc/2/net are logically the same directory.

However, changing the mode to 550 _and_ changing uid and gid will help.

> >   - need to alter "(inode->i_mode =3D=3D (S_IFDIR|S_IRUGO|S_IXUGO))" ch=
ecks
> >     to honour non-pid directories.
>=20
> I see this in the patch, but can't really comment without reviewing the
> code in full context myself.

As Spender commented, this is a weird thing to recognize pids from other
files, which is needed due to some weird caching :)

> >   - what if one keeps open /proc/PID/ while executing set*id/capable
> >     binary?
>=20
> Then they deliberately grant this privilege to this process (and maybe
> to its heirs).  I see no problem with that.

Ehh...  I mean another thing:

Process A with UID=3D1000 opens /proc/123/, while 123 has UID=3D1000.

123 exec's setuid binary, /proc/123/ becomes unaccessible to A.

However, A still keeps the directory opened and may read its contents.

> > +	if (pid->hide_net &&
> > +	    (!capable(CAP_NET_ADMIN) && !in_group_p(pid->pid_gid)))
>=20
> capable() sets a flag when it makes use of the capability (or at least
> it used to), visible via pacct.  So, unless anything has changed in this
> area, it is best to check capable() last, such that it's only reached
> when it actually makes a difference.  Thus, I'd write:
>=20
> 	if (pid->hide_net && !in_group_p(pid->pid_gid) &&
> 	    !capable(CAP_NET_ADMIN))

OK.

> Also, what did you mean by the extra braces?  Just separating the
> setting check from the permissions check for readability?

Initially I wrote some ||, so the braces were needed.  Will remove.


Thanks you for the comments, will fix and repost,

--=20
Vasiliy

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN691cAAoJEBoUx9gkVaZcCmwP/RffSn81sl+iwg5gpQY+t4cY
SM9WEOC5qGdMRUmFE5B6Ihx/johHze5uHWlUlY6XqUsUQE4PyDsfNzy4j4OUBCkF
IUptEVATQg/bhU3Vz42BCpGgGRuZX9RCJI/weYslXxzxC7wTp3WZNyn6nuvvMBE6
Ap2MJgPA/I13VP6MmDUAHG77FOECEMPGcXqP0D0YbmSgoCU58nwevEF1wyD1phJ1
3LL1Yz11+d99aVFlsgnil1B5UMLssTtH8C0gFhvpSHSe0PawbqhCqWnVlm+P62ph
dqXKKeg2f9KzcRaDGSRm6WBFwRq0wBWITM/k2aSStgwtJUWfPP7wuWYCotwTYan+
ObcCs5FUVYkF2xVm3T4qhLXa5nvANLczVL/xGHWx5E/ibnfU16tPRnmLO7u12MQ6
Q2nkE1B9XGI54SaUtJT+59ALdv/Lho9jz3HLP/b6Z4Gswklgkvx8+5ZBdSPRvdR4
M/dJmP0bCwOybe4jo3I/21ZaQdAjkpc3bqoPF5IKkzyl2fzDME1iFjUInE17TtG5
OzsgvEz6/uGI8AS/amwm0B8Luw8gwsn99I8uobHqML8fi6XplYz60ZdGWbh1E3S5
sLKqnxrHpjPz8Yf0ZZkvvXZ9yy+CyigwkgQsM/3ph4lbLqIqeC5Molv+3MQHEy18
bXFoYSprbDESvqaeREF9
=AFhC
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
