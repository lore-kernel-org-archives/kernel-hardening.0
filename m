Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1453255778.25071.26.camel@perches.com>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	<1453226922-16831-3-git-send-email-keescook@chromium.org>
	<1453255778.25071.26.camel@perches.com>
Date: Fri, 22 Jan 2016 15:29:45 -0800
Message-ID: <CAGXu5jLXuz529eyE9o0u88+iBzUqbB_Mh3Jbp43EZNgJDnWu2Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 2/8] lib: add "on" and "off" to strtobool
To: Joe Perches <joe@perches.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Borkmann <daniel@iogearbox.net>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 6:09 PM, Joe Perches <joe@perches.com> wrote:
> On Tue, 2016-01-19 at 10:08 -0800, Kees Cook wrote:
>> Several places in the kernel expect to use "on" and "off" for their
>> boolean signifiers, so add them to strtobool.
>
> Several places in the kernel use a char address like
> fs/cifs/cifs_debug.c
>
>
>         char c;
>         ...
>
>
>         if (strtobool(&c, ...))
>
> Using s[1] might cause problems for those uses.

Oh ew. Thanks for noticing that.

>> diff --git a/lib/string.c b/lib/string.c
> []
>> @@ -635,12 +635,15 @@ EXPORT_SYMBOL(sysfs_streq);
>>   * @s: input string
>>   * @res: result
>>   *
>> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
>> - * Otherwise it will return -EINVAL.  Value pointed to by res is
>> - * updated upon finding a match.
>> + * This routine returns 0 iff the first character is one of 'Yy1Nn0', or
>> + * [oO][NnFf] for "on" and "off". Otherwise it will return -EINVAL.  Value
>> + * pointed to by res is updated upon finding a match.
>>   */
>>  int strtobool(const char *s, bool *res)
>>  {
>> +     if (!s)
>> +             return -EINVAL;
>> +
>>       switch (s[0]) {
>>       case 'y':
>>       case 'Y':
>> @@ -652,6 +655,21 @@ int strtobool(const char *s, bool *res)
>>       case '0':
>>               *res = false;
>>               break;
>> +     case 'o':
>> +     case 'O':
>> +             switch (s[1]) {
>> +             case 'n':
>> +             case 'N':
>> +                     *res = true;
>> +                     break;
>> +             case 'f':
>> +             case 'F':
>
> Perhaps
>                 switch (tolower(s[1])) {
> is more readable

I opted to let the compiler deal with optimizing this, and I left the
switch statement as close to original as possible.

-Kees

>
>> +                     *res = false;
>> +                     break;
>> +             default:
>> +                     return -EINVAL;
>> +             }
>> +             break;
>
> or maybe /* fallthrough */
>
>>       default:
>>               return -EINVAL;
>>       }
>



-- 
Kees Cook
Chrome OS & Brillo Security
