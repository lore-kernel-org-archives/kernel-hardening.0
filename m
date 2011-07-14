Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 14 Jul 2011 19:14:50 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110714151450.GA30153@openwall.com>
References: <20110612130953.GA3709@albatros> <20110706173631.GA5431@albatros> <CA+55aFyfjG1h2zkkGai_VPM8p5bhWhvNXs1HvuWMgxv4RSywYw@mail.gmail.com> <20110706185932.GB3299@albatros> <20110711165900.GA14319@openwall.com> <20110711185635.GA2072@albatros> <20110713094856.GA20924@openwall.com> <20110714141557.GA29900@openwall.com> <20110714142755.GA30981@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110714142755.GA30981@albatros>
Subject: Re: [kernel-hardening] RLIMIT_NPROC check in set_user()
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Thu, Jul 14, 2011 at 06:27:55PM +0400, Vasiliy Kulikov wrote:
> On Thu, Jul 14, 2011 at 18:15 +0400, Solar Designer wrote:
> > I found it:
> > 
> > Subject: [PATCH] set*uid() must not fail-and-return on OOM/rlimits
> > http://lists.openwall.net/linux-kernel/2006/08/20/4
> 
> I've already referenced to it in the first email posted to LKML (as [2]):
> http://www.openwall.com/lists/kernel-hardening/2011/06/12/9

Oh, I did not check your references.  Sorry. ;-(

Alexander
