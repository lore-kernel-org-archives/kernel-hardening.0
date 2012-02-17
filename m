Reply-To: kernel-hardening@lists.openwall.com
From: pageexec@freemail.hu
Date: Fri, 17 Feb 2012 15:23:23 +0200
MIME-Version: 1.0
Reply-to: pageexec@freemail.hu
Message-ID: <4F3E62DB.6956.CF97716@pageexec.freemail.hu>
In-reply-to: <20120217014008.GA18763@kroah.com>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>, <20120217010624.GA6541@outflux.net>, <20120217014008.GA18763@kroah.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: Add overflow protection to kref
To: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>
Cc: Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On 16 Feb 2012 at 17:40, Greg KH wrote:

> > A quick search gives me:
> > CVE-2005-3359: https://bugzilla.redhat.com/show_bug.cgi?id=175769
> > CVE-2006-3741: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b8444d00762703e1b6146fce12ce2684885f8bf6
> 
> Neither of those are kref issues, just bugs with other types of
> counting things.

kref is just one of the many users of the atomic type that use it for refcounting.
and kref users are no more immune to programming mistakes that can result in overflow
than direct atomic users.

> Again, I don't know of any kref overflows that have ever happened, so
> trying to "protect" this type of thing, seems odd to me.

well, do you analyze all bugreports/patches/etc for this problem? even if you did
it's easy to miss them because kref_put has so many wrappers around it whose uses
would also have to be checked for. anyway, a very lightweight grep in the git log
turned up these (i spent half a minute on it only, don't expect a flood ;):

14660ccd599dc7bd6ecef17408bd76dc853f9b77
ece84241b93c4693bfe0a8ec9a043a16d216d0cd
b65d457913d1c0644394287d5d834373f42fb99a
94735ec4044a6d318b83ad3c5794e931ed168d10
