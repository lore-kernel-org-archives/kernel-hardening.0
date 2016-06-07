Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <57573559.1010607@suse.com>
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
 <CAGXu5jKC=HuCe3FPuuzjAZ+SX6C5AnhMp5BWwLhi8xVXhTGjEg@mail.gmail.com>
 <57458279.6080009@suse.com> <CAGXu5jKw_oQNCVUH+o_k-W+5Z7LDXgJ3UpP24a+y4S0Ny+gvvw@mail.gmail.com>
 <57573559.1010607@suse.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 Jun 2016 13:59:53 -0700
Message-ID: <CAGXu5j+y-fb7qj+C2xNXzqT1-ob-CJq7D6cLHGNTcpCWMPGA4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v9 0/4] Introduce GCC plugin infrastructure
To: Michal Marek <mmarek@suse.com>
Cc: Emese Revfy <re.emese@gmail.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 7, 2016 at 1:58 PM, Michal Marek <mmarek@suse.com> wrote:
> Dne 25.5.2016 v 19:12 Kees Cook napsal(a):
>> On Wed, May 25, 2016 at 3:46 AM, Michal Marek <mmarek@suse.com> wrote:
>>> On 2016-05-24 19:04, Kees Cook wrote:
>>>> On Mon, May 23, 2016 at 3:07 PM, Emese Revfy <re.emese@gmail.com> wrote:
>>>>> This patch set introduce the GCC plugin infrastructure with examples for testing
>>>>> and documentation.
>>>>>
>>>>> GCC plugins are loadable modules that provide extra features to the compiler.
>>>>> They are useful for runtime instrumentation and static analysis.
>>>>>
>>>>> The infrastructure supports all gcc versions from 4.5 to 6.0, building
>>>>> out-of-tree modules and building in a separate directory. Cross-compilation
>>>>> is supported too but currently only the x86, arm, arm64 and uml architectures enable plugins.
>>>>>
>>>>> This infrastructure was ported from grsecurity/PaX. Based on work created by the PaX Team.
>>>>> It is a CII project supported by the Linux Foundation.
>>>>>
>>>>> Emese Revfy (4):
>>>>>  Shared library support
>>>>>  GCC plugin infrastructure
>>>>>  Add Cyclomatic complexity plugin
>>>>>  Add sancov plugin
>>>>
>>>> Michal, once -rc1 is out, can you carry this for -next?
>>>
>>> Yes.
>>
>> Awesome! Please consider it:
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>
> I applied the series to kbuild.git#kbuild now, sorry for the delay.

Awesome! Thank you very much. I'll prepare the latent entropy plugin
for -next now too.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
