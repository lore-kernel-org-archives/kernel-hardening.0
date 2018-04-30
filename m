Date: Mon, 30 Apr 2018 07:26:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] inode: debugfs_create_dir uses mode permission from
 parent
Message-ID: <20180430142643.GA18468@kroah.com>
References: <20180427123547.15727-1-tmricht@linux.ibm.com>
 <20180427134936.GA31171@kroah.com>
 <CAG48ez3WW49fGaNkG4rd7aFB7HXRKe24Yh_w55JWoG3Cz1HN2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3WW49fGaNkG4rd7aFB7HXRKe24Yh_w55JWoG3Cz1HN2A@mail.gmail.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Richter <tmricht@linux.ibm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, brueckner@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, kernel list <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 30, 2018 at 04:15:58PM +0200, Jann Horn wrote:
> On Fri, Apr 27, 2018 at 3:49 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > I'm going to add Kees and the kernel-hardning list here, as I'd like
> > their opinions for the patch below.
> >
> > Kees, do you have any problems with this patch?  I know you worked on
> > making debugfs more "secure" from non-root users, this should still keep
> > the intial mount permissions all fine, right?  Anything I'm not
> > considering here?
> >
> > thanks,
> >
> > greg k-h
> >
> > On Fri, Apr 27, 2018 at 02:35:47PM +0200, Thomas Richter wrote:
> >> Currently function debugfs_create_dir() creates a new
> >> directory in the debugfs (usually mounted /sys/kernel/debug)
> >> with permission rwxr-xr-x. This is hard coded.
> >>
> >> Change this to use the parent directory permission.
> 
> AFAICS no inodes in debugfs have handlers for the ->rename, ->mkdir,
> ->create inode ops. What is write permission on debugfs directories
> useful for?

I doubt anything :)
