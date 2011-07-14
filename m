Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jul 2011 18:15:57 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110714141557.GA29900@openwall.com>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110711165900.GA14319@openwall.com> <20110711185635.GA2072@albatros> <20110713094856.GA20924@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713094856.GA20924@openwall.com>
Subject: Re: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Jul 13, 2011 at 01:48:56PM +0400, Solar Designer wrote:
> LKML discussion a few years ago, ...

I found it:

Subject: [PATCH] set*uid() must not fail-and-return on OOM/rlimits
http://lists.openwall.net/linux-kernel/2006/08/20/4

and lots of followups.  Alan NAK'ed the change at the time.  I think he
was wrong.  Anyway, there's useful info in that thread - please read it.

I think we should only bring the process killing suggestion up when the
move of RLIMIT_NPROC check is committed.

Alexander
