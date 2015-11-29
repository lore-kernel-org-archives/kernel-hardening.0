Reply-To: kernel-hardening@lists.openwall.com
From: Richard Weinberger <richard@nod.at>
Message-ID: <565B7F7D.80208@nod.at>
Date: Sun, 29 Nov 2015 23:43:09 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] user controllable usermodehelper in br_stp_if.c
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, bridge@lists.linux-foundation.org, Stephen Hemminger <stephen@networkplumber.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi!

By spawning new network and user namesapces an unprivileged user
is able to execute /sbin/bridge-stp within the initial mount namespace
with global root rights.
While this cannot directly be used to break out of a container or gain
global root rights it could be used by exploit writers as valuable building block.

e.g.
$ unshare -U -r -n /bin/sh
$ brctl addbr br0
$ brctl stp br0 on # this will execute /sbin/bridge-stp

As this mechanism clearly cannot work with containers and seems to be legacy code
I suggest not calling call_usermodehelper() at all if we're not in the initial user namespace.
What do you think?

Thanks,
//richard
