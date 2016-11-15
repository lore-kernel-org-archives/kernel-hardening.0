Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <f1e8522c-b33a-77ce-c2c3-9c74a468e663@au1.ibm.com>
References: <20160626173451.c8406cd0c7a87cc3f94d9753@gmail.com>
 <70eb7a4c-be31-3fdd-a5b4-8075b29b3b38@au1.ibm.com> <CAGXu5j+8=3Vxm52Y2QbkDiCPx5X6DWemPO7B=2kj2EdVQpLHpA@mail.gmail.com>
 <f1e8522c-b33a-77ce-c2c3-9c74a468e663@au1.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 15 Nov 2016 15:06:28 -0800
Message-ID: <CAGXu5jKD2r7Yz3GLekzbMZ+5qPqch7SLWUAbarvM7XR77=bgHw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH] powerpc/kernel: Disable the latent
 entropy plugin unconditionally
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 15, 2016 at 2:45 PM, Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> On 16/11/16 09:41, Kees Cook wrote:
>>
>> Just checking in: did these patches materialize? I'd love to see
>> plugins working on v4.10 for ppc.
>
>
> Working on it!
> https://github.com/ajdlinux/linux/tree/powerpc-gcc-plugin-infrastructure

Very cool, thanks!

> Just need to test with all the compilers to figure out which ones are broken
> so we can put a version check in...

Sounds good.

-Kees

-- 
Kees Cook
Nexus Security
