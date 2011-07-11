Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 11 Jul 2011 20:59:00 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110711165900.GA14319@openwall.com>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706185932.GB3299@albatros>
Subject: Re: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Jul 06, 2011 at 10:59:32PM +0400, Vasiliy Kulikov wrote:
> On Wed, Jul 06, 2011 at 11:01 -0700, Linus Torvalds wrote:
> > My reaction is: "let's just remote the crazy check from set_user()
> > entirely".
> 
> Honestly, I didn't expect such a positive reaction from you in the first
> reply :)

After this is taken care of, please also consider other ways set*id()
syscalls might fail on errors unrelated to the process possessing
appropriate privileges.  IIRC, set_user() could also fail when it's not
able to allocate an instance of "struct user" - unlikely, but possible.
I think the process must be killed on those errors.  There's no better
action to take on them.

Thanks,

Alexander
