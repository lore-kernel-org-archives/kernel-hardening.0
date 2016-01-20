Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 20 Jan 2016 21:11:20 +0100
From: Jann Horn <jann@thejh.net>
Message-ID: <20160120201120.GA11861@pc.thejh.net>
References: <20160119112812.GA10818@mwanda>
 <87ziw14263.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <87ziw14263.fsf@x220.int.ebiederm.org>
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 19, 2016 at 04:47:32PM -0600, Eric W. Biederman wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>
> > I like to look back over old CVEs to see how we could do better.  Here
> > is the list from 2015.  I got most of this information from the Ubuntu
> > CVE tracker.  Thanks Ubuntu!.  If it doesn't have a hash that means it
> > might not be fixed yet.
> >
> > CVE-2015-8709 : ptrace: race in user namespaces let's users trace root =
processes
>
> As this isn't a kernel bug,

I agree that it's not a kernel bug and not a kernel race - userspace
developers assumed security guarantees that the kernel didn't actually
provide.

However, I think that the kernel is missing documentation here and that
namespaces are designed somewhat unfortunately. A container that can be
created and securely, robustly entered by an unprivileged user would
have to work like this under the current rules as far as I can tell:

To create the container:
setsid
   [prevent tty pushback via /dev/tty]
set up tty IO forwarding if necessary
   [prevents tty pushback, possibly additional filtering]
unshare(CLONE_NEWUSER) to create a "purgatory" user ns.
Map the container owner to uid 0, map all uids that should be mapped into
   the container (including the container root) to 1 and higher (where
   1 is the container root).
stash FD to the purgatory user namespace somewhere in the outer ns
drop all privileges (open fds, ...)
setresuid(1,1,1) [still protected against ptrace by nondumpability]
unshare(CLONE_NEWUSER) to create the container's user ns
   [From here on, we can be ptraced by the ns root user from outside.
    The ns root user could ptrace us from outside at this point and=20
    see the outer namespaces through us, but that's okay, he'd have
    to already be in the outer user ns for that.]
set up other namespaces for the container
stash FDs to the container namespaces in the purgatory ns
let a process in the purgatory map the container uids and gids
do security-revelant setup work (setup bind mounts, ...)
   [be careful here, don't trust any files in container-controlled
    filesystem parts]
do security-irrelevant setup work
execlp("init")

Then, to enter the container:
setsid
   [prevent tty pushback via /dev/tty]
set up tty IO forwarding if necessary
   [prevents tty pushback, possibly additional filtering]
Enter the purgatory user ns, referenced through an FD
setresuid(1, 1, 1) [still protected against ptrace by nondumpability]
enter container namespaces, but not the user namespace yet
   [We don't really trust the namespace FDs supplied by the setup
    process because they were sent after the ns root user gained
    ptrace access, but that's okay because we can only move downward
    using setns(), so we end up in namespaces below the purgatory
    that are owned by the namespace root. That's good enough.]
drop privileges (open fds, ...)
enter container user namespace [ns root gains ptrace access]

The purgatory user ns is necessary because without privileges in the
container's parent user namespace, it's not possible to switch to the
container root uid prior to entering it (except with an ugly hack
involving a temporary namespace, newuidmap and a (possibly temporary)
setuid binary), and more importantly, even given access to the
container's root uid, it's not possible to actually enter the
container without having the container owner's euid unless you have
CAP_SYS_ADMIN in the outer namespace.

(Of course, this could be simplified with a setuid root helper, but I
don't think anyone wants more of those to be necessary.)

> and is not a race, and no one has even
> bothered to see if any userspace processes are this stupid I don't even
> think that qualifies as a CVE.

I know of at least two projects that enter user namespaces without the
necessary care, one of them is LXC.


> There is room for improvement in this area but I don't see how this
> qualifies as a CVE.

I think I agree with that.

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJWn+noAAoJED4KNFJOeCOouG0P/3LeJXOHK/zm5DX2fZKRn/v0
bJpfgdaZeEAdhaLfZidnWoHZlvkuRJTVxrlWjE5aN8pQMO2LkjAXmsvtmNRiGgO0
zKFNr+Moyk4vo5BDSRTvBgaPgzOIO+7rkquxmYza4COJE2mO48z89DOH+a8QaxCh
qfxdg+ZCrJEmF0CmUwu/sItCtxlDdCL9J9izdsf/UmW02SfGhAuwCn2ALZGIYNDo
xUY/col6zVUlctYUnuRa0mOIkSJPML01XhdkYfPRweoABYzBwuWg8r6dbk+jSv+W
sXl7T3gSiC08EFDbxxYtoHiCoT76Dx0nKLfyr93uYbs8WFm2Y39wEyC4clDUQM4L
o2yCi1OaI41UfHkMehlFsi4KuR4k1hvOEhrOSnHtGl+K7oHSOYHE68/a33g+ZBmf
BUSZWGG0U3Jk2FGQQkAfBCO2edpGyiWxZIhDBLlHf++US7lN7YPdNaVS5XWDgDT5
HNPkjzyjqIFcZfRs6fg4rs57J32IFuzmV377glEI76ZTzQ47mICctBakjPE7Pz9N
B1jlka4HNcxW9SIybjKWwECh4cChXnZw8x4Og6CQGrqsbzxovknIlU+XrTzYBGeM
bdUBnSMvez6Sy4KINwTqlWusZFNv7kyHQvQvfHnp6nyDmthBfD4vKurw8CX1xp0V
QZ2Y7TRYCjsOYoWvVeWB
=ddtl
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
