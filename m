Reply-To: kernel-hardening@lists.openwall.com
References: <1455844533-24787-1-git-send-email-labbott@fedoraproject.org>
 <CAGXu5jLREPiCHSwk1LGKJm0pPGpD8O4S+4xu5=Aw_x+COLBXWg@mail.gmail.com>
 <56C79301.5040003@redhat.com>
 <CAGXu5jJ9py=VTyPDzAzD87XXUuMAOE-f+x+5eLUns_yxtkDWiA@mail.gmail.com>
 <56C7A02F.7070902@redhat.com>
 <CAGXu5jLdQNx7ineLf0zv67O30ituQ3a8WHKLBN5FzGVjMz27Bg@mail.gmail.com>
 <56CB866A.8070306@redhat.com>
 <CAGXu5jLXDmyGqXWqFp4dzmKmmfmZ+dW53200OByS2+0_63CT+Q@mail.gmail.com>
 <CAGXu5jJz-dWvHFV9jeQhT-r-bTFGxYypBniTjwnw9qp_LhLJ-w@mail.gmail.com>
 <56CE072F.7060804@redhat.com>
 <CAGXu5jKq-A+ysyP0TZSK1qT5Scu_9ekHU_GgYaQQJm9ftNjEqw@mail.gmail.com>
 <CAGXu5jLVwbaGpeHuMuZOc2H3gc=_pQ=Mao6jD71r3ZJ+6eDu_A@mail.gmail.com>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <56CE58BA.3080900@redhat.com>
Date: Wed, 24 Feb 2016 17:28:26 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLVwbaGpeHuMuZOc2H3gc=_pQ=Mao6jD71r3ZJ+6eDu_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCHv2] lkdtm: Add READ_AFTER_FREE test
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@fedoraproject.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/24/2016 03:37 PM, Kees Cook wrote:
> On Wed, Feb 24, 2016 at 1:48 PM, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Feb 24, 2016 at 11:40 AM, Laura Abbott <labbott@redhat.com> wrote:
>>> Yep, looks like the v1 patches and not the v2 patches which fix
>>> a known issue with the zeroing.
>>
>> Ah-ha, I'll go find those and retest.
>
> I sent out a series that was rebased. It works for me, but I want to
> make sure I didn't make any glaring issues. I've also sent some fixes
> to the lkdtm tests. One thing that stands out to me still is that the
> READ_AFTER_FREE never shows poisoning. I remain confused, since
> obviously if zeroing is working, it's being correctly poisoned...
>
> -Kees
>

I'll review the rebased series you sent out for the page poisoning patches.
If it's okay with you, I'll pull in the updates to the LKDTM test. If you
test with slub_debug=P on the command line do you see the READ_AFTER_FREE
test working as expected? Setting that on the command line will set up
the poisoning which should make the READ_AFTER_FREE test fail.

Thanks,
Laura
