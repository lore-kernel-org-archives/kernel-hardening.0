MIME-Version: 1.0
In-Reply-To: <23def981-3f61-8421-b46d-94f75b293003@redhat.com>
References: <20171201113447.GA5234@pjb1027-Latitude-E5410> <23def981-3f61-8421-b46d-94f75b293003@redhat.com>
From: park jinbum <jinb.park7@gmail.com>
Date: Sun, 3 Dec 2017 11:32:24 +0900
Message-ID: <CAErMHp9ZvUiCO4RUSin3jCBghBFNg=xPaLGyB+3vOPjD0zTBgA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening][PATCH v2 3/3] arm: mm: dump: add checking for
 writable and executable pages
To: Laura Abbott <labbott@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Afzal Mohammed <afzal.mohd.ma@gmail.com>, Mark Rutland <mark.rutland@arm.com>, linux@armlinux.org.uk, gregkh@linuxfoundation.org, Kees Cook <keescook@chromium.org>, vladimir.murzin@arm.com, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

I agree with your opinion, Laura.
I'll make a new version to take advantage of the existing pg_level and
bits arrays.

Thanks,
Jinbum Park.

2017-12-02 6:59 GMT+09:00 Laura Abbott <labbott@redhat.com>:
> On 12/01/2017 03:34 AM, Jinbum Park wrote:
>>
>> +static inline bool is_prot_ro(struct pg_state *st)
>> +{
>> +       if (st->level < 4) {
>> +       #ifdef CONFIG_ARM_LPAE
>> +               if ((st->current_prot &
>> +               (L_PMD_SECT_RDONLY | PMD_SECT_AP2)) ==
>> +               (L_PMD_SECT_RDONLY | PMD_SECT_AP2))
>> +                       return true;
>> +       #elif __LINUX_ARM_ARCH__ >= 6
>> +               if ((st->current_prot &
>> +               (PMD_SECT_APX | PMD_SECT_AP_READ | PMD_SECT_AP_WRITE)) ==
>> +               (PMD_SECT_APX | PMD_SECT_AP_WRITE))
>> +                       return true;
>> +       #else
>> +               if ((st->current_prot &
>> +               (PMD_SECT_AP_READ | PMD_SECT_AP_WRITE)) == 0)
>> +                       return true;
>> +       #endif
>> +       } else {
>> +               if ((st->current_prot & L_PTE_RDONLY) == L_PTE_RDONLY)
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
>> +static inline bool is_prot_nx(struct pg_state *st)
>> +{
>> +       if (st->level < 4) {
>> +               if ((st->current_prot & PMD_SECT_XN) == PMD_SECT_XN)
>> +                       return true;
>> +       } else {
>> +               if ((st->current_prot & L_PTE_XN) == L_PTE_XN)
>> +                       return true;
>> +       }
>> +
>> +       return false;
>> +}
>
>
> I know arm64 checks the bits directly, but the arm32 code is a bit
> more fiddly and I have mixed feelings about copying and pasting
> the checks. It would be cleaner if we could take advantage of
> the existing pg_level and bits arrays. I also don't have my heart
> set on this so if nobody else objects, the code can stay as is.
>
> Thanks,
> Laura
