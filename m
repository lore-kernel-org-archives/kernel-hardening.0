Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 30 Jun 2016 21:48:15 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160630214815.GH9922@io.lakedaemon.net>
References: <20160622124707.GC9922@io.lakedaemon.net>
 <CAJcbSZHbGJBhTMeAEJF4VVazYypDCO=UFJpi8y0kXKrdM=WXQA@mail.gmail.com>
 <CAGXu5jK_42d+jkPr4Ck0iL52-ignY9gq-eUZ73_YuhKJERrRxA@mail.gmail.com>
 <20160623193358.GL9922@io.lakedaemon.net>
 <CAGXu5jJpFPuOrKSWT_H1oeTDObQKcgqL9ZwAHUV7y9=how_n9w@mail.gmail.com>
 <CAKv+Gu8SGsLCbVqDQVtZU4nNf=zzhONSFoSNF_Q29VmD=TZMWw@mail.gmail.com>
 <20160624011115.GU9922@io.lakedaemon.net>
 <CAKv+Gu_p5WLXBO0k=VWuX_ps1SMSte4_BhZFQY9pjveiTbSxAA@mail.gmail.com>
 <20160624160238.GV9922@io.lakedaemon.net>
 <CAGXu5j+hsPcrCAEcY-s9EDDUVqWOhpdx5iGNTBRqCqkExOJh5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+hsPcrCAEcY-s9EDDUVqWOhpdx5iGNTBRqCqkExOJh5w@mail.gmail.com>
Subject: [kernel-hardening] Re: devicetree random-seed properties, was: "Re: [PATCH v7 0/9]
 x86/mm: memory area address KASLR"
To: Kees Cook <keescook@chromium.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Garnier <thgarnie@google.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Fri, Jun 24, 2016 at 12:04:32PM -0700, Kees Cook wrote:
> On Fri, Jun 24, 2016 at 9:02 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> > Thomas,
> >
> > Sorry for wandering off the topic of your series.  The big take away for
> > me is that you and Kees are concerned about x86 systems pre-RDRAND.
> > Just as I'm concerned about deployed embedded systems without bootloader
> > support for hw-rngs and so forth.
> >
> > Whatever final form the approach takes for ARM/dt, I'll make sure we can
> > extend it to legacy x86 systems.
> 
> Yeah, this seems like a productive conversation to me. :)
> 
> > Ard,
> >
> > On Fri, Jun 24, 2016 at 12:54:01PM +0200, Ard Biesheuvel wrote:
> >> On 24 June 2016 at 03:11, Jason Cooper <jason@lakedaemon.net> wrote:
> >> > On Thu, Jun 23, 2016 at 10:05:53PM +0200, Ard Biesheuvel wrote:
> > ...
> >> >> On arm64, only DT is used for KASLR (even when booting via ACPI). My
> >> >> first draft used register x1, but this turned out to be too much of a
> >> >> hassle, since parsing the DT is also necessary to discover whether
> >> >> there is a 'nokaslr' argument on the kernel command line. So the
> >> >> current implementation only supports a single method, which is the
> >> >> /chosen/kaslr-seed uint64 property.
> >> >
> >> > Ok, just to clarify (after a short offline chat), my goal is to set a
> >> > userspace,random-seed <addr, len> property in the device tree once.
> >> > The bootloader scripts would also only need to be altered once.
> >> >
> >> > Then, at each boot, the bootloader reads the entirety of
> >> > /var/lib/misc/random-seed (512 bytes) into the configured address.
> >> > random-seed could be in /boot, or on a flash partition.
> >> >
> >> > The decompressor would consume a small portion of that seed for kaslr
> >> > and such.  After that, the rest would be consumed by random.c to
> >> > initialize the entropy pools.
> >> >
> >>
> >> I see. This indeed has little to do with the arm64 KASLR case, other
> >> than that they both use a DT property.
> >>
> >> In the arm64 KASLR case, I deliberately chose to leave it up to the
> >> bootloader/firmware to roll the dice, for the same reason you pointed
> >> out, i.e., that there is no architected way on ARM to obtain random
> >> bits. So in that sense, what you are doing is complimentary to my
> >> work, and a KASLR  aware arm64 bootloader would copy some of its
> >> random bits taken from /var/lib/misc/random-seed into the
> >> /chosen/kaslr-seed DT property.
> >
> > Here I disagree.  We have two distinct entropy sources; the hw-rng
> > currently feeding kaslr via the /chosen/kaslr-seed property, and the
> > seasoned userspace seed I propose handed in via an extra property.
> >
> > Having the bootloader conflate those two sources as if they are equal
> > seems to muddy the waters.  I prefer to have bootloaders tell me where
> > they got the data rather than to hope the bootloader sourced and mixed
> > it well.
> >
> >> Note that, at the moment, this DT property is only an internal
> >> contract between the kernel's UEFI stub and the kernel proper, so we
> >> could still easily change that if necessary.
> >
> > Ideally, I'd prefer to be deliberate with the DT properties, e.g.
> >
> > random-seed,hwrng     <--- bootloader reads from hw-rng
> > random-seed,userspace <--- bootloader reads file from us to addr
> >
> > The kernel decompressor can init kaslr with only one of the two
> > properties populated.  If both properties are present, then the
> > decompressor can extract a u64 from userspace-seed and mix it with
> > hwrng-seed before use.
> >
> > The small devicetree portion of my brain feels like 'kaslr-seed' is
> > telling the OS what to do with the value.  Whereas devicetree is
> > supposed to be describing the hardware.  Or, in this case, describing
> > the source of the data.
> >
> > Given that more entropy from more sources is useful for random.c a bit
> > later in the boot process, it might be worth making hwrng-seed larger
> > than u64 as well.  This way we can potentially seed random.c from two
> > sources *before* init even starts.  Without having to depend on the
> > kernel's hw-rng driver being probed.  After all, it might not have been
> > built, or it could be a module that's loaded later.
> >
> > I've attached a draft patch to chosen.txt.
> >
> > thx,
> >
> > Jason.
> >
> >
> > --------------->8---------------------------------
> > diff --git a/Documentation/devicetree/bindings/chosen.txt b/Documentation/devicetree/bindings/chosen.txt
> > index 6ae9d82d4c37..61f15f04bc0a 100644
> > --- a/Documentation/devicetree/bindings/chosen.txt
> > +++ b/Documentation/devicetree/bindings/chosen.txt
> > @@ -45,6 +45,52 @@ on PowerPC "stdout" if "stdout-path" is not found.  However, the
> >  "linux,stdout-path" and "stdout" properties are deprecated. New platforms
> >  should only use the "stdout-path" property.
> >
> > +random-seed properties
> > +----------------------
> > +
> > +The goal of these properties are to provide an entropy seed early in the boot
> > +process.  Typically, this is needed by the kernel decompressor for
> > +initializing KASLR.  At that point, the kernel entropy pools haven't been
> > +initialized yet, and any hardware rng drivers haven't been loaded yet, if they
> > +exist.
> > +
> > +The bootloader can attain these seeds and pass them to the kernel via the
> > +respective properties.  The bootloader is not expected to mix or condition
> > +this data in any way, simply read and pass.  Either one or both properties can
> > +be set if the data is available.
> > +
> > +random-seed,hwrng property
> > +--------------------------
> > +
> > +For bootloaders with support for reading from the system's hardware random
> > +number generator.  The bootloader can read a chunk of data from the hw-rng
> > +and set it as the value for this binary blob property.
> 
> As in the boot loader would change the value per-boot?

Yes-ish.  It's an opaque binary blob to the bootloader, but it does update
the devicetree at each boot.

This differs from the userspace approach because bootloaders supporting
devicetree (passing and updating) pre-date bootloader drivers for rngs.
So, if it can read from the hw rng, then it almost certainly can update
the devicetree.  Which is the preferred method for passing data in
devicetree world.

> Does this proposal include replacing /chosen/kaslr-seed with
> random-seed,hwrng? (Should the "chosen" path be used for hwrng too?)

Well, that's up to Ard.  ;-)  I'm simply trying to put my thoughts into
concrete terms for consideration.  If Ard and others are amenable to it,
then yes.  A kernel supporting reading seeds from these proposed DT
properties would not need kaslr-seed.

My objection to /chosen/kaslr-seed is that it doesn't follow the mantra
of DT; state what the object is, not how you think the OS should use it.
Second, by only feeding in enough entropy for seeding kaslr, we are
missing the opportunity to provide sufficient entropy for seeding the
system entropy pools before init is called.

If we need to add this code to support kaslr seeding (we do), then we
may as well solve initializing the system entropy pools while we are
here.  The increased maintenance burden should be negligible.

> > +
> > +/ {
> > +       chosen {
> > +               random-seed,hwrng = <0x1f 0x07 0x4d 0x91 ...>;
> > +       };
> > +};
> > +
> > +random-seed,userspace property
> > +------------------------------
> > +
> > +The goal of this property is to also provide backwards compatibility with
> > +existing systems.  The bootloaders on these deployed systems typically lack
> > +the ability to edit a devicetree or read from an hwrng.  The only requirement
> > +for a bootloader is that it be able to read a seed file generated by the
> > +previous boot into a pre-determined physical address and size.  This is
> > +typically done via boot scripting.
> 
> What happens on a cold boot?

Nothing different.  As long as the OS wrote a new seed blob to the known
location in the filesystem (traditionally /var/lib/misc/random-seed),
then the bootloader should read it in to RAM and then proceed with the
normal boot process.

I resisted calling out /var/lib/misc/random-seed specifically because a
lot of older bootloaders only have support for reading from FAT32 or,
worst case, flash.

In the FAT32-only scenario, most OSes will put the kernel and initrd on
a separate FAT32 partition (usually /boot) for the bootloader to read
from.  So, the bootloader can read /boot/random-seed into the RAM
address before executing the kernel.  /var/lib/misc/random-seed can be a
symlink to /boot, or the init scripts can be modified to write to both
locations.

> > +
> > +This property can then be set in the devicetree statically and parsed by a
> > +modern kernel without requiring a bootloader update.
> > +
> > +/ {
> > +       chosen {
> > +               random-seed,userspace = <0x40000 0x200>;
> > +       };
> > +};
> > +
> >  linux,booted-from-kexec
> >  -----------------------
> >

thx,

Jason.
