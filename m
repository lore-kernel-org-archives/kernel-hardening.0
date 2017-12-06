MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAErMHp9BBaJ8iNyjOS3nU+LUWNijL6FSOKSmVAYY_20nfB9nAQ@mail.gmail.com>
References: <20171204142553.GA3344@pjb1027-Latitude-E5410> <CAGXu5j+UHqJcxygGXk0jXYkK7AHzi1rU5SqvowfYT-OVKc6r5Q@mail.gmail.com>
 <CAErMHp9BBaJ8iNyjOS3nU+LUWNijL6FSOKSmVAYY_20nfB9nAQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 6 Dec 2017 15:26:22 -0800
Message-ID: <CAGXu5jJ+BbTwoM1DvwAJGRh=4EiMU1SOoPDPX2VmOC5w2cNHSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v3 1/3] arm: mm: dump: make page table
 dumping reusable
To: Jinbum Park <jinb.park7@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Afzal Mohammed <afzal.mohd.ma@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Laura Abbott <labbott@redhat.com>, Russell King <linux@armlinux.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Vladimir Murzin <vladimir.murzin@arm.com>, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 6, 2017 at 1:45 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
>>> +#ifndef __ASM_PTDUMP_H
>>> +#define __ASM_PTDUMP_H
>>> +
>>> +#ifdef CONFIG_ARM_PTDUMP_CORE
>>
>> Is this #ifdef needed? I think this file is only included in dump.c
>> and ptdump_debugfs.c, both of which are only built when
>> CONFIG_ARM_PTDUMP_CORE is defined.
>
> Looking at next patch in this patch-set series ([PATCH v3 3/3] arm:
> mm: dump: add checking for writable and executable pages),
> Not only dump.c and ptdump_debugfs.c but also arch/arm/mm/init.c
> include this file (ptdump.h) to call debug_checkwx().
> mm/init.c is not built only when CONFIG_ARM_PTDUMP_CORE is defined.
> So, This #ifdef seems not be needed for this patch, but is needed for
> this patch-set series.
>
>
>>> +static int ptdump_init(void)
>>> +{
>>> +       ptdump_initialize();
>>> +       return ptdump_debugfs_register(&kernel_ptdump_info,
>>> +                                       "kernel_page_tables");
>>
>> This changes the return value of ptdump_init. This should do similar
>> to what was done before:
>>
>> return ptdump_debugfs_register(&kernel_ptdump_info,
>> "kernel_page_tables") ? 0 : -ENOMEM;
>
>
> ptdump_debugfs_register() already returns what you think.
>
>>> +int ptdump_debugfs_register(struct ptdump_info *info, const char *name)
>>> +{
>>> +       struct dentry *pe;
>>> +
>>> +       pe = debugfs_create_file(name, 0400, NULL, info, &ptdump_fops);
>>> +       return pe ? 0 : -ENOMEM;
>>> +
>>> +}
>
> So "return ptdump_debugfs_register(~~)" is fine.

Ah! Yes, I totally missed the change from create_file to
debugfs_register. Sorry for the noise!

-Kees

-- 
Kees Cook
Pixel Security
