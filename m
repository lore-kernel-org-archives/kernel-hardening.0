From: Laura Abbott <labbott@redhat.com>
References: <20171103230426.19114-1-labbott@redhat.com>
 <20171103230426.19114-2-labbott@redhat.com>
 <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
Message-ID: <228e1cbb-ec61-b54a-4093-2d377e90ca6b@redhat.com>
Date: Mon, 6 Nov 2017 12:38:08 -0800
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJconGeCQbRX9XOpPo__dgDY5zdRtb5G6ce7Wih7SHyiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [RFC PATCH 2/2] x86: Allow paranoid __{get,put}_user
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/03/2017 05:14 PM, Kees Cook wrote:
> On Fri, Nov 3, 2017 at 4:04 PM, Laura Abbott <labbott@redhat.com> wrote:
>> __{get,put}_user calls are designed to be fast and have no checks,
>> relying on the caller to have made the appropriate calls previously.
>> It's very easy to forget a check though, leaving the kernel vulnerable
>> to exploits. Add an option to do the checks and kill the kernel if it
>> catches something bad.
>>
>> Signed-off-by: Laura Abbott <labbott@redhat.com>
>> ---
>> This is the actual implemtation for __{get,put}_user on x86 based on
>> Mark Rutland's work for arm66
>> lkml.kernel.org/r/<20171026090942.7041-1-mark.rutland@arm.com>
>>
>> x86 turns out to be easier since the safe and unsafe paths are mostly
>> disjoint so we don't have to worry about gcc optimizing out access_ok.
>> I tweaked the Kconfig to someting a bit more generic.
>>
>> The size increase was ~8K in text with a config I tested.
> 
> Specifically, this feature would have caught the waitid() bug in 4.13
> immediately.
> 
>> ---
>>  arch/x86/Kconfig               |  3 +++
>>  arch/x86/include/asm/uaccess.h | 11 ++++++++++-
>>  security/Kconfig               | 11 +++++++++++
>>  3 files changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index 2fdb23313dd5..10c6e150a91e 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -261,6 +261,9 @@ config RWSEM_XCHGADD_ALGORITHM
>>  config GENERIC_CALIBRATE_DELAY
>>         def_bool y
>>
>> +config ARCH_HAS_PARANOID_UACCESS
>> +       def_bool y
>> +
>>  config ARCH_HAS_CPU_RELAX
>>         def_bool y
>>
>> diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
>> index d23fb5844404..767febe1c720 100644
>> --- a/arch/x86/include/asm/uaccess.h
>> +++ b/arch/x86/include/asm/uaccess.h
>> @@ -132,6 +132,13 @@ extern int __get_user_bad(void);
>>  #define __inttype(x) \
>>  __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
>>
>> +
>> +#define verify_uaccess(dir, ptr)                                        \
>> +({                                                                      \
>> +        if (IS_ENABLED(CONFIG_PARANOID_UACCESS))                  \
>> +                BUG_ON(!access_ok(dir, (ptr), sizeof(*(ptr))));         \
>> +})
>> +
>>  /**
>>   * get_user: - Get a simple variable from user space.
>>   * @x:   Variable to store result.
>> @@ -278,6 +285,7 @@ do {                                                                        \
>>         typeof(ptr) __pu_ptr = (ptr);                                   \
>>         retval = 0;                                                     \
>>         __chk_user_ptr(__pu_ptr);                                       \
>> +       verify_uaccess(VERIFY_WRITE, __pu_ptr);                         \
>>         switch (size) {                                                 \
>>         case 1:                                                         \
>>                 __put_user_asm(x, __pu_ptr, retval, "b", "b", "iq",     \
>> @@ -293,7 +301,7 @@ do {                                                                        \
>>                 break;                                                  \
>>         case 8:                                                         \
>>                 __put_user_asm_u64((__typeof__(*ptr))(x), __pu_ptr,     \
>> -                               retval, \ errret);                      \
>> +                               retval, errret);                        \
>>                 break;                                                  \
>>         default:                                                        \
>>                 __put_user_bad();                                       \
> 
> Which tree is this against? I don't see the weird line break in my tree?
> 

Uggggh I meant to fold this into the previous patch.

>> @@ -359,6 +367,7 @@ do {                                                                        \
>>         typeof(ptr) __gu_ptr = (ptr);                                   \
>>         retval = 0;                                                     \
>>         __chk_user_ptr(__gu_ptr);                                       \
>> +       verify_uaccess(VERIFY_READ, __gu_ptr);                          \
>>         switch (size) {                                                 \
>>         case 1:                                                         \
>>                 __get_user_asm(x, __gu_ptr, retval, "b", "b", "=q",     \
> 
> Does __put/get_user_size_ex() need additions too? (And does
> put/get_user_ex() lack access_ok() checks as-is? Looks like the users
> are have access_ok() checks, but that naming really shouldn't be
> aliased to "put/get_user_ex" -- otherwise it gives the impression it's
> doing access_ok() checks...)
> 

Possibly? A better approach might be to add the check to uaccess_try
which is where all the users already are. The users of these APIs are
pretty limited and I doubt they'd get used randomly.

Thanks,
Laura
