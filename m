MIME-Version: 1.0
In-Reply-To: <20180131080714.svyq34reb7d2pwmf@gmail.com>
References: <151703971300.26578.1185595719337719486.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151703977742.26578.8362387033092864423.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180128095027.hqrcpnholsvukdzd@gmail.com> <CAPcyv4gA5eBYGsb+5WGcCnyB-8MB6qeO9Sw6aZNvaBCtb7OK1w@mail.gmail.com>
 <20180131080714.svyq34reb7d2pwmf@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 1 Feb 2018 12:23:01 -0800
Message-ID: <CAPcyv4jdDkwGFW1oqdL_wDS1b55ryB5OjDb3PmERsMZ0mz=z=g@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] x86/spectre: report get_user mitigation for spectre_v1
Content-Type: text/plain; charset="UTF-8"
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch <linux-arch@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 31, 2018 at 12:07 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Sun, Jan 28, 2018 at 1:50 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Dan Williams <dan.j.williams@intel.com> wrote:
>> >
>> >> Reflect the presence of 'get_user', '__get_user', and 'syscall'
>> >> protections in sysfs. Keep the "Vulnerable" distinction given the
>> >> expectation that the places that have been identified for 'array_idx'
>> >> usage are likely incomplete.
>> >
>> > (The style problems/inconsistencies of the previous patches are repeated here too,
>> > please fix.)
>> >
>> >>
>> >> Cc: Thomas Gleixner <tglx@linutronix.de>
>> >> Cc: Ingo Molnar <mingo@redhat.com>
>> >> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> >> Cc: x86@kernel.org
>> >> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> Reported-by: Jiri Slaby <jslaby@suse.cz>
>> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> >> ---
>> >>  arch/x86/kernel/cpu/bugs.c |    2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
>> >> index 390b3dc3d438..01d5ba48f745 100644
>> >> --- a/arch/x86/kernel/cpu/bugs.c
>> >> +++ b/arch/x86/kernel/cpu/bugs.c
>> >> @@ -269,7 +269,7 @@ ssize_t cpu_show_spectre_v1(struct device *dev,
>> >>  {
>> >>       if (!boot_cpu_has_bug(X86_BUG_SPECTRE_V1))
>> >>               return sprintf(buf, "Not affected\n");
>> >> -     return sprintf(buf, "Vulnerable\n");
>> >> +     return sprintf(buf, "Vulnerable: Minimal user pointer sanitization\n");
>> >
>> > Btw., I think this string is still somewhat passive-aggressive towards users, as
>> > it doesn't really give them any idea about what is missing from their system so
>> > that they can turn it into not vulnerable.
>> >
>> > What else is missing that would turn this into a "Mitigated" entry?
>>
>> Part of the problem is that there are different sub-classes of Spectre
>> variant1 vulnerabilities. For example, speculating on the value of a
>> user pointer returned from get_user() is mitigated by these kernel
>> changes. However, cleaning up occasions where the CPU might speculate
>> on the validity of a user-controlled pointer offset, or
>> user-controlled array index is only covered by manual inspection of
>> some noisy / incomplete tooling results. I.e. the handful of
>> array_index_nospec() usages in this series is likely incomplete.
>>
>> The usage of barrier_nospec() in __get_user() and open coded
>> array_index_nospec() in get_user() does raise the bar and mitigates an
>> entire class of problems. Perhaps it would be reasonable to have
>> cpu_show_spectre_v1() emit:
>>
>>     "Mitigation: __user pointer sanitization"
>
> Yeah, so I think the ideal approach would be if we emitted _both_ pieces of
> information:
>
>      Mitigation: __user pointer sanitization
>      Vulnerable: incomplete array index sanitization
>
> I.e. we inform the user about the mitigation measures that are active, but we also
> fully inform that we think it's incomplete at this stage.

But that would assume that it's only array index sanitization that we
need to worry about. The get_user() protections were interesting
because they showed a class of potential leaks near pointer
de-references not necessarily arrays. So I think it's more likely the
case that we'll add more "Mitigation:" lines over time.
