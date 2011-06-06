Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Mon, 6 Jun 2011 23:20:01 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110606192001.GA3241@albatros>
References: <20110603191153.GB514@openwall.com>
 <20110604054758.GA4063@albatros>
 <20110604132054.GC2583@openwall.com>
 <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20110605201025.GA9541@openwall.com>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 00:10 +0400, Solar Designer wrote:
> On Sun, Jun 05, 2011 at 11:47:46PM +0400, Vasiliy Kulikov wrote:
> > On Sun, Jun 05, 2011 at 23:26 +0400, Solar Designer wrote:
> > > On Sun, Jun 05, 2011 at 10:24:31PM +0400, Vasiliy Kulikov wrote:
> > > > TODO/thoughs:
> > > >   - /proc/pid/net/ currently doesn't show ANYTHING, even "." and ".=
=2E".
> > > >     This is confusing :)
> > >=20
> > > Ouch.  Can't you simply restrict its perms such that this directory
> > > can't be listed unless you have privs?
=2E..
> > Another solution - create a fake net namespace and process this
> > namespace if not enough permissions :)  It also removes weird netstat
> > errors like "seems like networking was disabled for this kernel".

A fake net namespace works perfect:

$ LANG=3DC netstat -nlp4
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address State       PID=
/Program name

No warning from netstat.  I remember brctl didn't properly handle
missing sysfs files, so fake files make sense.


Will repost the patch after I'm sure that changing hidepid works well
with inode caching (I see a bug in my current implementation).


Thanks,

--=20
Vasiliy

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJN7ShdAAoJEBoUx9gkVaZcHqMQAJD6HaCHLi+JN/beZvOfeTFx
lr9hmeDcOZpwXT3uawl12DeshncKJa1X1tDlXlBh8lw6oipT2hTGaHe0yCAAIoRS
n33HxuXwAQxOa6QZslkRgytbxHXddfpPKDm8h2qcLW91dG1Gt/LiCUMyoPUEYnGk
QYFt0YEt2kwr7hCq7JfrX0QegU2twERtJ90iQbrHPpJEifiRmAFfioufEvDRgDcl
PzKmF6uFuCQPe683fayFuTzvAGmxOVyk9jbQ8kaoMxjMIVUcFG3ISr2A29QsyzXW
Cn5PxVxBTbSn9xqUoVN8wYk9JLt3RocI4kCaEz5BdgFIzPW84pamxXmXScKHlNkb
HfP0JfPsWt6wpayh+fpZwc+6nM21KRTcKZe4kyfuo/2pwPeKY5l6Kvme1uOGmQci
3jrNP5ZWUtaFzqVqKn7ubebfGF6tMvMMpvqTZBoG15w5kjXAtzbXaEiBApG88ktO
KVxK9pqnsOcekt0QGGwnDQL5h3VxealwXwPpNLVzqgfs45pQPM9+pvnLaFakx19R
oXkBnA0iSCkMjqr+TvlGioYtrqjuHxbZ2RNx27V1Ub9P1GZAyvh0Ad6cCD9LOgca
WsG1pouFeMrDDaAY3CPjBpo/lq661Q/1YYzQiPHZq5fDO2LWFj2is3x0oGB3Vqbv
w0ZzhRij9piDyf00fSwE
=d6PS
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
