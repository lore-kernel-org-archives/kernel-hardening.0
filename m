Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2011 13:48:56 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110713094856.GA20924@openwall.com>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110711165900.GA14319@openwall.com> <20110711185635.GA2072@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110711185635.GA2072@albatros>
Subject: Re: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Mon, Jul 11, 2011 at 10:56:35PM +0400, Vasiliy Kulikov wrote:
> On Mon, Jul 11, 2011 at 20:59 +0400, Solar Designer wrote:
> > After this is taken care of, please also consider other ways set*id()
> > syscalls might fail on errors unrelated to the process possessing
> > appropriate privileges.  IIRC, set_user() could also fail when it's not
> > able to allocate an instance of "struct user" - unlikely, but possible.
> > I think the process must be killed on those errors.  There's no better
> > action to take on them.
> 
> As Spender has noticed, small allocations may not fail, they are forced
> to use __GFP_NOFAIL.

Oh, I now seem to recall that this was mentioned to me before (in an
LKML discussion a few years ago, but I failed to find it now).  My
opinion on this was/is that if we have a "can't happen" condition -
set_user() failure - then this is yet another reason why we must not
merely return -EAGAIN on this condition.  Rather, killing the process
would be a safer action to take.  As long as our assumptions are
correct, it can't happen anyway.  If/when the assumptions break (with a
code revision, or because we've overlooked something now), the safer
action will be taken (after my proposed change).

Thanks,

Alexander
