Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 8 Dec 2011 23:21:43 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20111208192143.GB9794@albatros>
References: <20111119110126.GA11468@albatros>
 <20111119110212.GB11468@albatros>
 <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1112051451470.3938@sister.anvils>
Subject: [kernel-hardening] Re: [RFC v2 2/3] procfs: add hidepid= and gid= mount options
To: Hugh Dickins <hughd@google.com>
Cc: kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Greg KH <greg@kroah.com>, Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>, Oleg Nesterov <oleg@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Hugh,

On Mon, Dec 05, 2011 at 14:55 -0800, Hugh Dickins wrote:
> On Sat, 19 Nov 2011, Vasiliy Kulikov wrote:
> > This patch adds support of mount options to restrict access to
> > /proc/PID/ directories.  The default backward-compatible "relaxed"
> > behaviour is left untouched.
> 
> This patch, in 3.2.0-rc3-next-20111202, leaks tasks: watch
> while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Thank you very much for the report!

Unfortunately, I have no time to look at it now, will try to debug the
issue these weekends.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
