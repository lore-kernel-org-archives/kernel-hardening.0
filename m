Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jKRW1T6uR1ax7Oah_-nHCayALJ-DWj=MMoXwvdZvAfV-w@mail.gmail.com>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
 <1465336628-18219-4-git-send-email-keescook@chromium.org> <941dc7f5-03a2-8a98-8888-7e92985699e3@redhat.com>
 <CAGXu5jKRW1T6uR1ax7Oah_-nHCayALJ-DWj=MMoXwvdZvAfV-w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Jun 2016 14:26:56 -0700
Message-ID: <CAGXu5jJTx3gzzXSNK5x+ui0x7kGhvrV8vhKVoc33T2W3h4T5XQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 3/5] lkdtm: add function for testing .rodata section
To: Laura Abbott <labbott@redhat.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 8, 2016 at 8:46 AM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jun 7, 2016 at 6:02 PM, Laura Abbott <labbott@redhat.com> wrote:
>> On 06/07/2016 02:57 PM, Kees Cook wrote:
>>>
>>> This adds a function that lives in the .rodata section. The section
>>> flags are corrected using objcopy since there is no way with gcc to
>>> declare section flags in an architecture-agnostic way.
>>>
>>
>> Permit me to be the bearer of bad architecture news once again. With
>> arm64 cross compiler (both Fedora 6.1.1 and Linaro 5.1)
>>
>>   CC      drivers/misc/lkdtm_rodata.o
>>   OBJCOPY drivers/misc/lkdtm_rodata_objcopy.o
>>   LD      drivers/misc/lkdtm.o
>> drivers/misc/lkdtm_rodata_objcopy.o: file not recognized: File format not
>> recognized
>> scripts/Makefile.build:423: recipe for target 'drivers/misc/lkdtm.o' failed
>> make[2]: *** [drivers/misc/lkdtm.o] Error 1
>> scripts/Makefile.build:440: recipe for target 'drivers/misc' failed
>> make[1]: *** [drivers/misc] Error 2
>> Makefile:985: recipe for target 'drivers' failed
>> make: *** [drivers] Error 2
>>
>>
>> As far as I can tell this is because arm64 defines OBJCOPYFLAGS and they get
>> propagated to objcopy
>>
>> aarch64-linux-gnu-objcopy -O binary -R .note -R .note.gnu.build-id -R
>> .comment
>>         -S --set-section-flags .text=alloc,readonly
>>         --rename-section .text=.rodata drivers/misc/lkdtm_rodata.o
>> drivers/misc/lkdtm_rodata_objcopy.o
>>
>> vs x86
>>
>> objcopy  --set-section-flags .text=alloc,readonly --rename-section
>> .text=.rodata
>>         drivers/misc/lkdtm_rodata.o drivers/misc/lkdtm_rodata_objcopy.o
>>
>>
>> specifically it's the -O binary that seems to break things, the same failure
>> happens on x86 as well with the the same commands. It works if I clear out
>> the OBJCOPYFLAGS variable first but I don't think that's the correct way to
>> fix this.
>>
>> Thanks,
>> Laura
>>
>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> ---
>>>  drivers/misc/Makefile       |  7 +++++++
>>>  drivers/misc/lkdtm.h        |  6 ++++++
>>>  drivers/misc/lkdtm_core.c   | 24 +++++++++++++++++-------
>>>  drivers/misc/lkdtm_rodata.c | 10 ++++++++++
>>>  4 files changed, 40 insertions(+), 7 deletions(-)
>>>  create mode 100644 drivers/misc/lkdtm.h
>>>  create mode 100644 drivers/misc/lkdtm_rodata.c
>>>
>>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>>> index c3cb6ad8cc37..b2d3d68dfa22 100644
>>> --- a/drivers/misc/Makefile
>>> +++ b/drivers/misc/Makefile
>>> @@ -59,3 +59,10 @@ obj-$(CONFIG_CXL_BASE)               += cxl/
>>>  obj-$(CONFIG_PANEL)             += panel.o
>>>
>>>  lkdtm-$(CONFIG_LKDTM)          += lkdtm_core.o
>>> +lkdtm-$(CONFIG_LKDTM)          += lkdtm_rodata_objcopy.o
>>> +

If I add:

OBJCOPYFLAGS :=

here, it seems to fix things...

>>> +OBJCOPYFLAGS_lkdtm_rodata_objcopy.o := \
>>> +                       --set-section-flags .text=alloc,readonly \
>>> +                       --rename-section .text=.rodata
>>> +$(obj)/lkdtm_rodata_objcopy.o: $(obj)/lkdtm_rodata.o
>>> +       $(call if_changed,objcopy)
>
> Uhhhh... How is arm64 injecting those extra flags? OBJCOPYFLAGS is
> being set with := here?
>
> In related news I need to figure out how to get my cross-compiler
> builds more well scripted...
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security



-- 
Kees Cook
Chrome OS & Brillo Security
