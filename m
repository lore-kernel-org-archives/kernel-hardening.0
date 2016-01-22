Reply-To: kernel-hardening@lists.openwall.com
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
 <20160122171954.GA3945@davidb.org>
From: Laura Abbott <laura@labbott.name>
Message-ID: <56A28029.2060608@labbott.name>
Date: Fri, 22 Jan 2016 11:16:57 -0800
MIME-Version: 1.0
In-Reply-To: <20160122171954.GA3945@davidb.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v4 0/8] introduce post-init read-only
 memory
To: kernel-hardening@lists.openwall.com
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 1/22/16 9:19 AM, David Brown wrote:
> On Tue, Jan 19, 2016 at 10:08:34AM -0800, Kees Cook wrote:
>
>> This introduces __ro_after_init as a way to mark such memory, and uses
>> it on the x86 vDSO to kill an extant kernel exploitation method. Also
>> adds a new kernel parameter to help debug future use and adds an lkdtm
>> test to check the results.
>
> I've tested these patches on 32-bit ARM using the provoke-crashes
> test.  However, they do require CONFIG_ARM_KERNMEM_PERMS to be enabled
> as well, which does incur additional memory usage.
>
> Do we want to consider making CONFIG_ARM_KERNMEM_PERMS default y for
> security reasons, and just document that memory-constrained systems
> may want to turn it off?
>
> I'll test the arm64 next.
>
> David

Kees had previously pushed a patch to do so but it exposed a couple of
underlying issues, mostly with low power paths
(c.f. http://article.gmane.org/gmane.linux.ports.arm.kernel/471199,
http://article.gmane.org/gmane.linux.kernel.mm/143489)
Those will need to be all fixed up before this could be made default.

Thanks,
Laura
