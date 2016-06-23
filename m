Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2016 20:16:03 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160623201603.GN9922@io.lakedaemon.net>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
 <20160622124707.GC9922@io.lakedaemon.net>
 <CAJcbSZHbGJBhTMeAEJF4VVazYypDCO=UFJpi8y0kXKrdM=WXQA@mail.gmail.com>
 <CAGXu5jK_42d+jkPr4Ck0iL52-ignY9gq-eUZ73_YuhKJERrRxA@mail.gmail.com>
 <20160623193358.GL9922@io.lakedaemon.net>
 <CACXcFmnu5M_pQw5oTU+P6j7udj2vJSjctHDT0NY5Xc3uuf-Ovg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACXcFmnu5M_pQw5oTU+P6j7udj2vJSjctHDT0NY5Xc3uuf-Ovg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v7 0/9] x86/mm: memory area address
 KASLR
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hey Sandy,

On Thu, Jun 23, 2016 at 03:45:54PM -0400, Sandy Harris wrote:
> Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > Modern systems that receive a seed from the bootloader via the
> > random-seed property (typically from the hw-rng) can mix both sources
> > for increased resilience.
> >
> > Unfortunately, I'm not very familiar with the internals of x86
> > bootstrapping.  Could GRUB be scripted to do a similar task?  How would
> > the address and size of the seed be passed to the kernel?  command line?
> 
> One suggestion is at:
> http://www.av8n.com/computer/htm/secure-random.htm#sec-boot-image

Yes, this is very similar to the latent_entropy series that I think Kees
just merged.  Well, at a high level, it is.  'store a seed in the
kernel, use it at reboot'.

These approaches are good in that they provide yet another source of
entropy to the kernel.  However, both suffer from the kernel binary
being very static in time and across distro installs.  Particularly with
embedded systems.  It almost becomes a long term secret.  Which, the
longer it lives, the less chance there is of it being secret.

I'm not really comfortable with what John suggests, here:

"""
Next step: It should be straightforward to write a tool that efficiently
updates the stored seed within the boot image. Updating MUST occur
during provisioning, before the device gets booted for the first time
... and also from time to time thereafter. Updating the boot image isn’t
be quite as simple as dd of=/var/lib/urandom/random-seed but neither is
it rocket surgery. The cost is utterly negligible compared to the cost
of a security breach, which is the relevant comparison.
"""

Editing the installed kernel binary to add the seed is exposing the
system to unnecessary risk of bricking the system (e.g. powerfail
 halfway through) [0].  Yes, this can be mitigated by following a similar
process to kernel updates, but why?  The bootloader already knows how to
read a file into RAM.  We just need to put it in the right place and
tell it to do so.  And userspace already writes a new random-seed during
system init and clean shutdown.

We just need to connect the dots so deployed systems can use the seed
earlier without having to hack the kernel or update the bootloader.
Which, while possible, a lot of folks are skittish to do.

thx,

Jason.

[0] I imagine it also borks code-signing...
