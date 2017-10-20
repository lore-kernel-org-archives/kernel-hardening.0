MIME-Version: 1.0
In-Reply-To: <20171020082420.lsvu7mqjrgnahm5t@gmail.com>
References: <20171011203027.11248-1-thgarnie@google.com> <20171011203027.11248-2-thgarnie@google.com>
 <20171020082420.lsvu7mqjrgnahm5t@gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 20 Oct 2017 09:28:00 +0100
Message-ID: <CAKv+Gu9XMnNA0UoGfFMQmC9=Ryh6dcOduxH+tq49bcdvBwhyQw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v1 01/27] x86/crypto: Adapt assembly for PIE support
To: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Garnier <thgarnie@google.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Matthias Kaehlcke <mka@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, Andy Lutomirski <luto@kernel.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Chris Wright <chrisw@sous-sol.org>, Alok Kataria <akataria@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Borislav Petkov <bp@alien8.de>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christopher Li <sparse@chrisli.org>, Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Dou Liyang <douly.fnst@cn.fujitsu.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lukas Wunner <lukas@wunner.de>, Masahiro Yamada <yamada.masahiro@socionext.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Markus Trippelsdorf <markus@trippelsdorf.de>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, Rik van Riel <riel@redhat.com>, David Howells <dhowells@redhat.com>, Waiman Long <longman@redhat.com>, Kyle Huey <me@kylehuey.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>, Peter Foley <pefoley2@pefoley.com>, Paul Bolle <pebolle@tiscali.nl>, Jiri Kosina <jkosina@suse.cz>, "H . J . Lu" <hjl.tools@gmail.com>, Rob Landley <rob@landley.net>, Baoquan He <bhe@redhat.com>, =?UTF-8?B?SmFuIEggLiBTY2jDtm5oZXJy?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>, "x86@kernel.org" <x86@kernel.org>, "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@vger.kernel.org>, virtualization@lists.linux-foundation.org, xen-devel <xen-devel@lists.xenproject.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, KVM devel mailing list <kvm@vger.kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 20 October 2017 at 09:24, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Thomas Garnier <thgarnie@google.com> wrote:
>
>> Change the assembly code to use only relative references of symbols for the
>> kernel to be PIE compatible.
>>
>> Position Independent Executable (PIE) support will allow to extended the
>> KASLR randomization range below the -2G memory limit.
>
>> diff --git a/arch/x86/crypto/aes-x86_64-asm_64.S b/arch/x86/crypto/aes-x86_64-asm_64.S
>> index 8739cf7795de..86fa068e5e81 100644
>> --- a/arch/x86/crypto/aes-x86_64-asm_64.S
>> +++ b/arch/x86/crypto/aes-x86_64-asm_64.S
>> @@ -48,8 +48,12 @@
>>  #define R10  %r10
>>  #define R11  %r11
>>
>> +/* Hold global for PIE suport */
>> +#define RBASE        %r12
>> +
>>  #define prologue(FUNC,KEY,B128,B192,r1,r2,r5,r6,r7,r8,r9,r10,r11) \
>>       ENTRY(FUNC);                    \
>> +     pushq   RBASE;                  \
>>       movq    r1,r2;                  \
>>       leaq    KEY+48(r8),r9;          \
>>       movq    r10,r11;                \
>> @@ -74,54 +78,63 @@
>>       movl    r6 ## E,4(r9);          \
>>       movl    r7 ## E,8(r9);          \
>>       movl    r8 ## E,12(r9);         \
>> +     popq    RBASE;                  \
>>       ret;                            \
>>       ENDPROC(FUNC);
>>
>> +#define round_mov(tab_off, reg_i, reg_o) \
>> +     leaq    tab_off(%rip), RBASE; \
>> +     movl    (RBASE,reg_i,4), reg_o;
>> +
>> +#define round_xor(tab_off, reg_i, reg_o) \
>> +     leaq    tab_off(%rip), RBASE; \
>> +     xorl    (RBASE,reg_i,4), reg_o;
>> +
>>  #define round(TAB,OFFSET,r1,r2,r3,r4,r5,r6,r7,r8,ra,rb,rc,rd) \
>>       movzbl  r2 ## H,r5 ## E;        \
>>       movzbl  r2 ## L,r6 ## E;        \
>> -     movl    TAB+1024(,r5,4),r5 ## E;\
>> +     round_mov(TAB+1024, r5, r5 ## E)\
>>       movw    r4 ## X,r2 ## X;        \
>> -     movl    TAB(,r6,4),r6 ## E;     \
>> +     round_mov(TAB, r6, r6 ## E)     \
>>       roll    $16,r2 ## E;            \
>>       shrl    $16,r4 ## E;            \
>>       movzbl  r4 ## L,r7 ## E;        \
>>       movzbl  r4 ## H,r4 ## E;        \
>>       xorl    OFFSET(r8),ra ## E;     \
>>       xorl    OFFSET+4(r8),rb ## E;   \
>> -     xorl    TAB+3072(,r4,4),r5 ## E;\
>> -     xorl    TAB+2048(,r7,4),r6 ## E;\
>> +     round_xor(TAB+3072, r4, r5 ## E)\
>> +     round_xor(TAB+2048, r7, r6 ## E)\
>>       movzbl  r1 ## L,r7 ## E;        \
>>       movzbl  r1 ## H,r4 ## E;        \
>> -     movl    TAB+1024(,r4,4),r4 ## E;\
>> +     round_mov(TAB+1024, r4, r4 ## E)\
>>       movw    r3 ## X,r1 ## X;        \
>>       roll    $16,r1 ## E;            \
>>       shrl    $16,r3 ## E;            \
>> -     xorl    TAB(,r7,4),r5 ## E;     \
>> +     round_xor(TAB, r7, r5 ## E)     \
>>       movzbl  r3 ## L,r7 ## E;        \
>>       movzbl  r3 ## H,r3 ## E;        \
>> -     xorl    TAB+3072(,r3,4),r4 ## E;\
>> -     xorl    TAB+2048(,r7,4),r5 ## E;\
>> +     round_xor(TAB+3072, r3, r4 ## E)\
>> +     round_xor(TAB+2048, r7, r5 ## E)\
>>       movzbl  r1 ## L,r7 ## E;        \
>>       movzbl  r1 ## H,r3 ## E;        \
>>       shrl    $16,r1 ## E;            \
>> -     xorl    TAB+3072(,r3,4),r6 ## E;\
>> -     movl    TAB+2048(,r7,4),r3 ## E;\
>> +     round_xor(TAB+3072, r3, r6 ## E)\
>> +     round_mov(TAB+2048, r7, r3 ## E)\
>>       movzbl  r1 ## L,r7 ## E;        \
>>       movzbl  r1 ## H,r1 ## E;        \
>> -     xorl    TAB+1024(,r1,4),r6 ## E;\
>> -     xorl    TAB(,r7,4),r3 ## E;     \
>> +     round_xor(TAB+1024, r1, r6 ## E)\
>> +     round_xor(TAB, r7, r3 ## E)     \
>>       movzbl  r2 ## H,r1 ## E;        \
>>       movzbl  r2 ## L,r7 ## E;        \
>>       shrl    $16,r2 ## E;            \
>> -     xorl    TAB+3072(,r1,4),r3 ## E;\
>> -     xorl    TAB+2048(,r7,4),r4 ## E;\
>> +     round_xor(TAB+3072, r1, r3 ## E)\
>> +     round_xor(TAB+2048, r7, r4 ## E)\
>>       movzbl  r2 ## H,r1 ## E;        \
>>       movzbl  r2 ## L,r2 ## E;        \
>>       xorl    OFFSET+8(r8),rc ## E;   \
>>       xorl    OFFSET+12(r8),rd ## E;  \
>> -     xorl    TAB+1024(,r1,4),r3 ## E;\
>> -     xorl    TAB(,r2,4),r4 ## E;
>> +     round_xor(TAB+1024, r1, r3 ## E)\
>> +     round_xor(TAB, r2, r4 ## E)
>
> This appears to be adding unconditional overhead to a function that was moved to
> assembly to improve its performance.
>

I did some benchmarking on this code a while ago and, interestingly,
it was slower than the generic C implementation (on a Pentium E2200),
so we may want to consider whether we still need this driver in the
first place.
