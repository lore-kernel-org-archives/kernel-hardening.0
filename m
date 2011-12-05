Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 5 Dec 2011 14:55:32 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
In-Reply-To: <20111119110212.GB11468@albatros>
Message-ID: <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
References: <20111119110126.GA11468@albatros> <20111119110212.GB11468@albatros>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC v2 2/3] procfs: add hidepid= and gid= mount options
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 19 Nov 2011, Vasiliy Kulikov wrote:
> This patch adds support of mount options to restrict access to
> /proc/PID/ directories.  The default backward-compatible "relaxed"
> behaviour is left untouched.

This patch, in 3.2.0-rc3-next-20111202, leaks tasks: watch
while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Hugh
