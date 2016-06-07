Reply-To: kernel-hardening@lists.openwall.com
References: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
 <CAGXu5jKC=HuCe3FPuuzjAZ+SX6C5AnhMp5BWwLhi8xVXhTGjEg@mail.gmail.com>
 <57458279.6080009@suse.com>
 <CAGXu5jKw_oQNCVUH+o_k-W+5Z7LDXgJ3UpP24a+y4S0Ny+gvvw@mail.gmail.com>
From: Michal Marek <mmarek@suse.com>
Message-ID: <57573559.1010607@suse.com>
Date: Tue, 7 Jun 2016 22:58:01 +0200
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKw_oQNCVUH+o_k-W+5Z7LDXgJ3UpP24a+y4S0Ny+gvvw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v9 0/4] Introduce GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>, Masahiro Yamada <yamada.masahiro@socionext.com>
List-ID: <kernel-hardening.lists.openwall.com>

Dne 25.5.2016 v 19:12 Kees Cook napsal(a):
> On Wed, May 25, 2016 at 3:46 AM, Michal Marek <mmarek@suse.com> wrote:
>> On 2016-05-24 19:04, Kees Cook wrote:
>>> On Mon, May 23, 2016 at 3:07 PM, Emese Revfy <re.emese@gmail.com> wrote:
>>>> This patch set introduce the GCC plugin infrastructure with examples for testing
>>>> and documentation.
>>>>
>>>> GCC plugins are loadable modules that provide extra features to the compiler.
>>>> They are useful for runtime instrumentation and static analysis.
>>>>
>>>> The infrastructure supports all gcc versions from 4.5 to 6.0, building
>>>> out-of-tree modules and building in a separate directory. Cross-compilation
>>>> is supported too but currently only the x86, arm, arm64 and uml architectures enable plugins.
>>>>
>>>> This infrastructure was ported from grsecurity/PaX. Based on work created by the PaX Team.
>>>> It is a CII project supported by the Linux Foundation.
>>>>
>>>> Emese Revfy (4):
>>>>  Shared library support
>>>>  GCC plugin infrastructure
>>>>  Add Cyclomatic complexity plugin
>>>>  Add sancov plugin
>>>
>>> Michal, once -rc1 is out, can you carry this for -next?
>>
>> Yes.
> 
> Awesome! Please consider it:
> 
> Acked-by: Kees Cook <keescook@chromium.org>

I applied the series to kbuild.git#kbuild now, sorry for the delay.

Michal
