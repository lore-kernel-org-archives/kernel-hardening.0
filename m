Date: Fri, 1 Dec 2017 15:52:57 +0000
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Message-ID: <20171201155257.561b2c27@alans-desktop>
In-Reply-To: <c5d9dd814f14467a8b756ebd27a07a75@AcuMS.aculab.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
	<1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com>
	<9fe9b2cd312748ddb31f63f9dc1b1ed8@AcuMS.aculab.com>
	<20171130175147.GA4124@openwall.com>
	<c5d9dd814f14467a8b756ebd27a07a75@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Solar Designer' <solar@openwall.com>, 'Salvatore Mesoraca' <s.mesoraca16@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

> > That's general misuse of /tmp.  Things like "command > /tmp/file"
> > without having pre-created the file with O_EXCL e.g. by mktemp(1).  
> 
> I'm sorry, I've been using Unix for over 30 years.
> /tmp is a place that temporary files were created - nothing special.
> Traditionally it was emptied on every boot.
> There was never anything that required files be created in any
> specific way.

And in 1978 you had to boot single user and use nckeck and icheck to fix
the filesystem up by hand, you had no networking, no systemd, no
sysvinit, no ANSI C. no X11 ... (shall I go on...)

There are reasons it all changed. The origin of /tmp is a compromise of
security and disk performance made in the 1970s about an OS that was
quite different, running on a machine with typically 256K of RAM, no RAM
disks, a single very expensive fixed head drive and a larger moving head
one.

The existence of /tmp in that form today is a bizarre historic quirk.
Fortunately if you want a perfectly safe /tmp/ use namespaces and every
user can have their own private /tmp.

Alan
