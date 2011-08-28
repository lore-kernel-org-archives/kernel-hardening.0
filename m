Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 28 Aug 2011 13:31:56 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110828093156.GA6291@albatros>
References: <20110804162009.GA2469@albatros>
 <20110823144430.75315ce8.akpm@linux-foundation.org>
 <20110826132909.GA8266@albatros>
 <20110826124021.15f8e20c.akpm@linux-foundation.org>
 <20110827190147.GA3015@albatros>
 <20110828092520.GA8537@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110828092520.GA8537@sun>
Subject: [kernel-hardening] Re: [PATCH v2] proc: fix races against execve() of /proc/PID/fd**
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>, David Rientjes <rientjes@google.com>, Stephen Wilson <wilsons@start.ca>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-kernel@vger.kernel.org, security@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi Cyrill,

On Sun, Aug 28, 2011 at 13:25 +0400, Cyrill Gorcunov wrote:
> On Sat, Aug 27, 2011 at 11:01:47PM +0400, Vasiliy Kulikov wrote:
> ...
> >  
> > +static int proc_pid_fd_link_getattr(struct vfsmount *mnt, struct dentry *dentry,
> > +		struct kstat *stat)
> > +{
> > +	struct inode *inode = dentry->d_inode;
> > +	struct task_struct *task = get_proc_task(inode);
> > +	int rc;
> > +
> 
> Are we sure if the task will be always valid here?
> 
> 	if (!task)
> 		return -ENOENT;

No, you're right.  It needs (task == NULL) check.  Thank you!

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
