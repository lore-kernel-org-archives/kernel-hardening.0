Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6731F279B79@ORSMSX107.amr.corp.intel.com>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <99FC4B6EFCEFD44486C35F4C281DC6731F279B79@ORSMSX107.amr.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 9 Jun 2016 10:48:57 -0700
Message-ID: <CAGXu5jKGzUTi886nBDSmnxAwvR99EnOpVdcEb8ma+TOcHZ2LKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: "Schaufler, Casey" <casey.schaufler@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 9, 2016 at 8:35 AM, Schaufler, Casey
<casey.schaufler@intel.com> wrote:
>> -----Original Message-----
>> From: Kees Cook [mailto:keescook@chromium.org]
>> Sent: Wednesday, June 08, 2016 2:12 PM
>> To: kernel-hardening@lists.openwall.com
>> Cc: Kees Cook <keescook@chromium.org>; Brad Spengler
>> <spender@grsecurity.net>; PaX Team <pageexec@freemail.hu>; Schaufler,
>> Casey <casey.schaufler@intel.com>; Rik van Riel <riel@redhat.com>; Christoph
>> Lameter <cl@linux.com>; Pekka Enberg <penberg@kernel.org>; David Rientjes
>> <rientjes@google.com>; Joonsoo Kim <iamjoonsoo.kim@lge.com>; Andrew
>> Morton <akpm@linux-foundation.org>
>> Subject: [RFC][PATCH v2 0/4] mm: Hardened usercopy
>>
>> Hi,
>>
>> This is v2 of the RFC patches for a mainline port of PAX_USERCOPY. After
>> I started writing tests for Casey's earlier port[1], I kept fixing things
>> further and further until I ended up with a whole new patch series. To
>> that end, I also took Rik's feedback and made a number of other changes
>> and clean-ups, which are noted in the "v2" history at the end.
>
> I love it when a plan comes together.
>
> Thank you for v2. Hopefully v1 was useful as a base.

Yeah, absolutely! It let me focus on a much smaller set of changes,
and the v2 really just ended up falling out of writing the lkdtm
tests. I spent a bunch of time scratching my head over the fact that
on x86 copy_*_user doesn't call down to __copy_*_user (!!), and
instead uses _copy_*_user (one underscore). After figuring that out,
then I was able to trip over all kinds of things with the whitelisting
pieces, so I separated that out, and it just continued from there.

I'd still really love to get a lot more testing, since I suspect my
bare-bones VM is not sufficiently exercising all the code that needs
whitelist tweaks, etc.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
