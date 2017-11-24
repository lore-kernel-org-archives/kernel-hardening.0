From: David Laight <David.Laight@ACULAB.COM>
Date: Fri, 24 Nov 2017 10:53:11 +0000
Message-ID: <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
        <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
 <20171122165144.07aea7ac@alans-desktop>
In-Reply-To: <20171122165144.07aea7ac@alans-desktop>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: 'Alan Cox' <gnomes@lxorguk.ukuu.org.uk>, Salvatore Mesoraca <s.mesoraca16@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W.
 Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Alan Cox
> Sent: 22 November 2017 16:52
>=20
> On Wed, 22 Nov 2017 09:01:46 +0100
> Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>=20
> > Disallows O_CREAT open missing the O_EXCL flag, in world or
> > group writable directories, even if the file doesn't exist yet.
> > With few exceptions (e.g. shared lock files based on flock())
>=20
> Enough exceptions to make it a bad idea.
>=20
> Firstly if you care this much *stop* having shared writable directories.
> We have namespaces, you don't need them. You can give every user their
> own /tmp etc.

Looks like a very bad idea to me as well.

Doesn't this stop all shell redirects into a shared /tmp ?
I'm pretty sure most programs use O_CREAT | O_TRUNC for output
files - they'll all stop working.

If there are some directories where you need to force O_EXCL you
need to make it a property of the directory, not the kernel.

	David
