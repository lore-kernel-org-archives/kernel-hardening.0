MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAK7LNAT13TrEbq5YR74YA1Snimn53MLjZFbHhbS2jLuvXn9a=g@mail.gmail.com>
References: <1530578352-18613-1-git-send-email-yamada.masahiro@socionext.com>
 <CAGXu5jKcWjm-56VRj=0kKU0Fb1ZrGgJ8WgesD0cN2x9WHTGwDw@mail.gmail.com> <CAK7LNAT13TrEbq5YR74YA1Snimn53MLjZFbHhbS2jLuvXn9a=g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 2 Jul 2018 19:25:26 -0700
Message-ID: <CAGXu5j+sQ9Fz+zYW8AXyDjuKtOSh-e7b_02N5nkD_DV7Voj10g@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: remove unused GCC_PLUGIN_SUBDIR
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Emese Revfy <re.emese@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Michal Marek <michal.lkml@markovi.net>, linux-kbuild <linux-kbuild@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 2, 2018 at 7:23 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> Hi Kees,
>
> 2018-07-03 11:18 GMT+09:00 Kees Cook <keescook@chromium.org>:
>> On Mon, Jul 2, 2018 at 5:39 PM, Masahiro Yamada
>> <yamada.masahiro@socionext.com> wrote:
>>> GCC_PLUGIN_SUBDIR has never been used.  If you really need this in
>>> the future, please re-add it then.
>>>
>>> For now, the code is unused. Remove.
>>>
>>> 'export HOSTLIBS' is not necessary either.
>>>
>>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>>
>> Acked-by: Kees Cook <keescook@chromium.org>
>>
>> Is this going via your tree, or should I take it via the gcc-plugins tree?
>>
>> Thanks!
>>
>> -Kees
>
> Could you pick it up to your tree?

Happily; thanks!

-Kees

-- 
Kees Cook
Pixel Security
