From: David Laight <David.Laight@ACULAB.COM>
Date: Thu, 30 Nov 2017 16:53:06 +0000
Message-ID: <9fe9b2cd312748ddb31f63f9dc1b1ed8@AcuMS.aculab.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W.
 Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Salvatore Mesoraca
> Sent: 22 November 2017 08:02
>=20
> Disallows O_CREAT open missing the O_EXCL flag, in world or
> group writable directories, even if the file doesn't exist yet.
> With few exceptions (e.g. shared lock files based on flock())
> if a program tries to open a file, in a sticky directory,
> with the O_CREAT flag and without the O_EXCL, it probably has a bug.
> This feature allows to detect and potentially block programs that
> act this way, it can be used to find vulnerabilities (like those
> prevented by patch #1) and to do policy enforcement.

(Going back to the original post)

I presume the 'vulnerabilities' are related to symlinks being created
just before the open?

Trouble is this change breaks a lot of general use of /tmp.
I always assumed that code that cared would use O_EXCL and
everything else wasn't worth subverting.

I found code in vi (and elsewhere) that subverted these checks
by opening with O_WRONLY if stat() showed the file existed and
O_CREAT|O_EXCL if it didn't.

I'm pretty sure that traditionally a lot of these opens were done
with O_CREAT|O_TRUNC.
Implementing that as unlink() followed by a create would stop
'random' (ok all) symlinks being followed.

Overall I'm pretty sure this change will break things badly somewhere.

	David
