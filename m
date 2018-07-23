MIME-Version: 1.0
In-Reply-To: <CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com>
References: <1531935483-30784-1-git-send-email-s.mesoraca16@gmail.com> <CAGXu5jK4q6HLDZ6jokTeDABbzVasY85Jo0HFNKYeaKWZYPjPKg@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Mon, 23 Jul 2018 10:55:55 +0900
Message-ID: <CAK7LNASyzWvJ6Bf1Zp4k=B-QFOHEg7YqeFErA2Gg9PNZadvuew@mail.gmail.com>
Subject: Re: [RFC] kconfig: add hardened defconfig helpers
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Salvatore Mesoraca <s.mesoraca16@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, LKML <linux-kernel@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

2018-07-20 14:15 GMT+09:00 Kees Cook <keescook@chromium.org>:
> +lkml, Masahiro, and linux-doc, just for wider review/thoughts.


I do not subscribe to kernel-hardening ML.

I do not see the original patch in lkml or kbuild/kconfig ML.


> On Wed, Jul 18, 2018 at 10:38 AM, Salvatore Mesoraca
> <s.mesoraca16@gmail.com> wrote:
>> Adds 4 new defconfig helpers (hardenedlowconfig,
>> hardenedmediumconfig, hardenedhighconfig,
>> hardenedextremeconfig) to enable various hardening
>> features.
>> The list of config options to enable is based on
>> KSPP's Recommended Settings[1] and on
>> kconfig-hardened-check[2], with some modifications.
>> These options are divided into 4 levels (low, medium,
>> high, extreme) based on their negative side effects, not
>> on their usefulness.
>> 'Low' level collects all those protections that have
>> (almost) no negative side effects.
>
> Likely the "Low" should be on-by-default already, but it's easier to
> bike-shed that separately. :)
>
>> 'Extreme' level collects those protections that may have
>> some many negative side effects that most people
>> wouldn't want to enable them.
>> Every feature in each level is briefly documented in
>> Documentation/security/hardenedconfig.rst, this file
>> also contain a better explanation of what every level
>> means.
>> To prevent this file from drifting from what the various
>> defconfigs actually do, it is used to dynamically
>> generate the config fragments.
>
> I like that the configs are generated from the docs! This makes things
> very sane to update.
>
>>
>> [1] http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Recommended_Settings
>> [2] https://github.com/a13xp0p0v/kconfig-hardened-check
>>
>> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
>> ---
>>  .gitignore                                 |    6 +
>>  Documentation/security/hardenedconfig.rst  | 1027 ++++++++++++++++++++++++++++
>>  Documentation/security/index.rst           |    1 +
>>  Makefile                                   |    6 +-
>>  scripts/kconfig/Makefile                   |   72 +-
>>  scripts/kconfig/build_hardened_fragment.sh |   54 ++
>>  6 files changed, 1143 insertions(+), 23 deletions(-)
>>  create mode 100644 Documentation/security/hardenedconfig.rst
>>  create mode 100755 scripts/kconfig/build_hardened_fragment.sh
>>

-- 
Best Regards
Masahiro Yamada
