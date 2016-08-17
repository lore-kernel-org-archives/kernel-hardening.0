Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160817160956.GD3482@linux.vnet.ibm.com>
References: <1471381865-25724-1-git-send-email-keescook@chromium.org>
 <1471381865-25724-5-git-send-email-keescook@chromium.org> <20160816212605.GY3482@linux.vnet.ibm.com>
 <CAGXu5jLGRL9PaLMVwGQ39_GUeMdBJgD03-PCYZ9KvtUF7aHt=Q@mail.gmail.com>
 <20160817000133.GZ3482@linux.vnet.ibm.com> <CAGXu5j+5i+sdAebvwSnwoDUFCTAHOV4za+jvw9stV5cSAEd_Lg@mail.gmail.com>
 <20160817160956.GD3482@linux.vnet.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Aug 2016 09:14:59 -0700
Message-ID: <CAGXu5jLYjXt5ko=4j9VBv1NuH-zKx=33LPfwXDz7wYcnD1-3PQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 4/5] bug: Provide toggle for BUG on data corruption
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Steven Rostedt <rostedt@goodmis.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>, Josef Bacik <jbacik@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 17, 2016 at 9:09 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Tue, Aug 16, 2016 at 05:09:53PM -0700, Kees Cook wrote:
>> On Tue, Aug 16, 2016 at 5:01 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Tue, Aug 16, 2016 at 02:42:28PM -0700, Kees Cook wrote:
>> >> On Tue, Aug 16, 2016 at 2:26 PM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> > On Tue, Aug 16, 2016 at 02:11:04PM -0700, Kees Cook wrote:
>> >> >> The kernel checks for several cases of data structure corruption under
>> >> >> either normal runtime, or under various CONFIG_DEBUG_* settings. When
>> >> >> corruption is detected, some systems may want to BUG() immediately instead
>> >> >> of letting the corruption continue. Many of these manipulation primitives
>> >> >> can be used by security flaws to gain arbitrary memory write control. This
>> >> >> provides CONFIG_BUG_ON_CORRUPTION to control newly added BUG() locations.
>> >> >>
>> >> >> This is inspired by similar hardening in PaX and Grsecurity, and by
>> >> >> Stephen Boyd in MSM kernels.
>> >> >>
>> >> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >> >
>> >> > OK, I will bite...  Why both the WARN() and the BUG_ON()?
>> >>
>> >> Mostly because not every case of BUG(CORRUPTED_DATA_STRUCTURE) is
>> >> cleanly paired with a WARN (see the workqueue addition that wants to
>> >> dump locks too). I could rearrange things a bit, though, and create
>> >> something like:
>> >>
>> >> #ifdef CONFIG_BUG_ON_CORRUPTION
>> >> # define CORRUPTED(format...) { \
>> >>     printk(KERN_ERR format); \
>> >>     BUG(); \
>> >> }
>> >> #else
>> >> # define CORRUPTED(format...) WARN(1, format)
>> >> #endif
>> >>
>> >> What do you think?
>> >
>> > First let me see if I understand the rationale...  The idea is to allow
>> > those in security-irrelevant environments, such as test systems, to
>> > have the old "complain but soldier on" semantics, while security-conscious
>> > systems just panic, thereby hopefully converting a more dangerous form
>> > of attack into a denial-of-service attack.
>>
>> Right, we don't want to wholesale upgrade all WARNs to BUGs. Just any
>> security-sensitive conditionals. And based on Laura's feedback, this
>> is really just about CONFIG_DEBUG_LIST now. We'll likely find some
>> more to add this to, but for the moment, we'll focus on list.
>>
>> Here are the rationales as I see it:
>>
>> - if you've enabled CONFIG_DEBUG_LIST
>>   - you want to get a report of the corruption
>>   - you want the kernel to _not operate on the structure_ (this went
>> missing when s/BUG/WARN/)
>> - if you've enabled CONFIG_BUG_ON_DATA_CORRUPTION
>>   - everything from CONFIG_DEBUG_LIST
>>   - you want the offending process to go away (i.e. BUG instead of WARN)
>>   - you may want the entire system to dump if you've set the
>> panic_on_oops sysctl (i.e. BUG)
>
> OK, this looks good to me.
>
> Just to be clear, if you've enabled neither CONFIG_DEBUG_LIST nor
> CONFIG_BUG_ON_DATA_CORRUPTION, then you get better performance, but are
> taking responsibility for using some other means of shielding your system
> from attack, correct?  (I believe that we do need to give the user this
> choice, just checking your intent.)

That's correct. (And in the future I intend to prove that the
performance impact is comically small and that DEBUG_LIST should be
yes-by-default, but that'll be a whole separate issue.)

>> > An alternative approach would be to make WARN() panic on systems built
>> > with CONFIG_BUG_ON_CORRUPTION, but we might instead want to choose which
>> > warnings are fatal on security-conscious systems.
>> >
>> > Or am I missing the point?
>> >
>> > At a more detailed level, one could argue for something like this:
>> >
>> > #define CORRUPTED(format...) \
>> > do { \
>> >         if (IS_ENABLED(CONFIG_BUG_ON_CORRUPTION)) { \
>> >                 printk(KERN_ERR format); \
>> >                 BUG(); \
>> >         } else { \
>> >                 WARN(1, format); \
>> >         } \
>> > } while (0)
>> >
>> > Some might prefer #ifdef to IS_ENABLED(), but the bare {} needs to
>> > be do-while in any case.
>>
>> Yup, this is almost exactly what I've got in the v2. I wanted to
>> enforce a control-flow side-effect, though, so I've included a
>> non-optional "return false" as well.
>
> Sounds good!  And yes, pulling the condition in makes a lot of sense
> to me as well.  Looking forward to seeing v3.

Great, thanks!

-Kees

-- 
Kees Cook
Nexus Security
