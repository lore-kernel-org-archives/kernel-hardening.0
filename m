Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 21 Nov 2011 16:34:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20111121163407.d8946ad8.akpm@linux-foundation.org>
In-Reply-To: <20111119110126.GA11468@albatros>
References: <20111119110126.GA11468@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC v2 1/3] procfs: parse mount options
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@MIT.EDU>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 19 Nov 2011 15:01:26 +0400
Vasiliy Kulikov <segooon@gmail.com> wrote:

> This patch adds support of procfs mount options.
> Actual mount options are coming in the next patches.

The patches look sane to me.

I assume that `mount -o remount' has been tested and works as expected?

I also assume that any file which was opened prior to the remount will
remain accessible to any process which has the fd.  Is this acceptable
from a security/operational POV?
