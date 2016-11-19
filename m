Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161119132832.GK3612@linux.vnet.ibm.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-4-git-send-email-elena.reshetova@intel.com> <20161119132832.GK3612@linux.vnet.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Sat, 19 Nov 2016 13:39:58 -0800
Message-ID: <CAGXu5jJ6Av611YQWvHNzVtEoprk-xnB9Ns9MGgg_rs95OPDMoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v4 PATCH 03/13] kernel: identify wrapping atomic usage
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <h.peter.anvin@intel.com>, Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Nov 19, 2016 at 5:28 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Thu, Nov 10, 2016 at 10:24:38PM +0200, Elena Reshetova wrote:
>> From: David Windsor <dwindsor@gmail.com>
>>
>> In some cases atomic is not used for reference
>> counting and therefore should be allowed to overflow.
>> Identify such cases and make a switch to non-hardened
>> atomic version.
>>
>> The copyright for the original PAX_REFCOUNT code:
>>   - all REFCOUNT code in general: PaX Team <pageexec@freemail.hu>
>>   - various false positive fixes: Mathias Krause <minipli@googlemail.com>
>>
>> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
>> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
>> Signed-off-by: David Windsor <dwindsor@gmail.com>
>
> Not a fan of the rename from atomic_t to atomic_wrap_t.

Yeah, the thread has grown considerably now. :) We're most likely
looking at carving off two of the common atomic_t usage patterns into
"stats_t" (with _add(), _sub(), and _read()), and "refcount_t" (with
_inc(), _inc_not_zero(), _dec_and_test(), and _read(), along with a
trap on overflow). With these in place, refcounts will be protected to
avoid use-after-free exploits, things that don't care about wrapping
will be annotated without a risk of them being turned into refcounts,
and the remaining atomic_t uses will be easier to audit for misuse.

-Kees

-- 
Kees Cook
Nexus Security
