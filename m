Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1484591068.1277.3.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 16 Jan 2017 13:24:28 -0500
In-Reply-To: <1484572984-13388-3-git-send-email-djalal@gmail.com>
References: <1484572984-13388-1-git-send-email-djalal@gmail.com>
	 <1484572984-13388-3-git-send-email-djalal@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4kl/sP09SYuoNyZReul5"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH v4 2/2] procfs/tasks: add a simple
 per-task procfs hidepid= field
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Lafcadio Wluiki <wluikil@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-4kl/sP09SYuoNyZReul5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> This should permit Linux distributions to more comprehensively lock
> down
> their services, as it allows an isolated opt-in for hidepid=3D for
> specific services. Previously hidepid=3D could only be set system-wide,
> and then specific services had to be excluded by group membership,
> essentially a more complex concept of opt-out.

I think it's a lot easier for them to introduce a proc group and then
figure out the very few exceptions that are needed vs. requiring a huge
number of opt-ins. I don't think the issue is difficulty in deploying
it, it's lack of interest. Android deployed it in 7.x without any major
issues. A good way to get people to use it would be adding proc groups
to major distributions and getting systemd to expose a simple toggle for
this, instead of requiring users to add /proc to fstab (not there by
default with systemd) and hard-wired the correct proc gid for that
distribution. Can then file bugs for packages needing the proc group.
For systemd itself, logind needs it since it drops the capability that
allows bypassing it. Other than that, it's mostly just polkit.
--=-4kl/sP09SYuoNyZReul5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlh9D9wWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKnpXD/0X2RA1duhkNSeCRdnCunvLL8P7
XUXiAIJbh4/1djRqEPU+GDFbBnjUveuvb3Q3DaqSneJmqWKgc3sgI/ff4QWvYNe6
rE6ojPklvTyTLI+OD19l3Xr+kqbiH6kp+07i5e84GKJsMkIUum5HfCbOIj13nYUH
G1krJW52oyIWET4Sm/CAN6iY3YuWmMuctCHbS+NQFi7698csLz0jKVInwEoMAxNE
mKTZ3gMxTp42I6rOpCBVR71wxnIaNBXPlIbnKqtdKQUm3UozAO061wjmKqOtDKV4
LRw928MZFw+dhm5mWp7zQgcVOtkmKhOGsG7OZyyzV2lUNZtTeLgFAS+DH8Nv+d++
KTwHQ7EI3rp6O1YUY35daarrJBYKac6D3xojWjeCL+1LdWPZspYrzojTymJCiJWA
cp0mcNw/08fVTVuB7J33OLebPmI7FEwmqP5/57jhXtlhjrE6ovXqvFm+8ULQGQ3m
EY1EsLibsUtkONIHVXNw22JD/uICaO/+43VzShm99id/4Xt4qZLOtVrZmeZIUn+W
DfJXUiJ116rGL9nrLiv1OkndXaBpEtczZcQMkHCAMeyadzXqVHydp6nf1Om/bt6j
JgnqiZdZGRuZ78u5MMx7KR2UVKf+RdXhsP0EFtIFOiEi2WvH/pAVFSu+YoQeDbFW
NDyJAeISLbhUdzXLpQ==
=OXb2
-----END PGP SIGNATURE-----

--=-4kl/sP09SYuoNyZReul5--
