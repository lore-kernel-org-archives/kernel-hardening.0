Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHp75VeJovidU+dWL6Su9YkpP+zmMUw=yrtLh2PmGRZRun-D8g@mail.gmail.com>
References: <1449697404-21076-1-git-send-email-keescook@chromium.org>
	<1449697404-21076-3-git-send-email-keescook@chromium.org>
	<CAHp75VeJovidU+dWL6Su9YkpP+zmMUw=yrtLh2PmGRZRun-D8g@mail.gmail.com>
Date: Fri, 11 Dec 2015 10:50:22 -0800
Message-ID: <CAGXu5jK8dTL5PVnF7G+xf=RvWX82G9NFy+jEqkNmV7V0zc-LxQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 2/8] lib: add "on" and "off" to strtobool
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Borkmann <daniel@iogearbox.net>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 11, 2015 at 9:00 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Wed, Dec 9, 2015 at 11:43 PM, Kees Cook <keescook@chromium.org> wrote:
>> Several places in the kernel expect to use "on" and "off" for their
>> boolean signifiers, so add them to strtobool.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> ---
>>  lib/string.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/lib/string.c b/lib/string.c
>> index 0323c0d5629a..d7550432f91c 100644
>> --- a/lib/string.c
>> +++ b/lib/string.c
>> @@ -635,12 +635,16 @@ EXPORT_SYMBOL(sysfs_streq);
>>   * @s: input string
>>   * @res: result
>>   *
>> - * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
>> + * This routine returns 0 iff the first character is one of 'Yy1Nn0', o=
r
>> + * 'Oo' when the second character is one of 'fFnN' (for "on" and "off")=
.
>
> Maybe
>
> =E2=80=A6or [Oo][FfNn] for "off" and "on"=E2=80=A6

Sure! That's more readable.

>>   * Otherwise it will return -EINVAL.  Value pointed to by res is
>>   * updated upon finding a match.
>>   */
>>  int strtobool(const char *s, bool *res)
>>  {
>
>> +       if (!s)
>> +               return -EINVAL;
>> +
>
> This change I think is better to do separately. Do we have even need for =
it?

I'm happy to separate it, sure. I added it here because several of the
__setup and param callers do a check for !NULL input, and it made this
cleaner. Also it seems sensible to do this check anyway.

>>         switch (s[0]) {
>>         case 'y':
>>         case 'Y':
>> @@ -652,6 +656,21 @@ int strtobool(const char *s, bool *res)
>>         case '0':
>>                 *res =3D false;
>>                 break;
>> +       case 'o':
>> +       case 'O':
>> +               switch (s[1]) {
>> +               case 'n':
>> +               case 'N':
>> +                       *res =3D true;
>> +                       break;
>> +               case 'f':
>> +               case 'F':
>> +                       *res =3D false;
>> +                       break;
>
>
>> +               default:
>> +                       return -EINVAL;
>> +               }
>> +               break;
>>         default:
>>                 return -EINVAL;
>
> Maybe in both cases
> default:
>  break;
> }
> =E2=80=A6
> }
> return -EINVAL;

I went back and forth on this. To switch to the fall-back being EINVAL
meant I had to change all the other "breaks" into "return 0", and it
just looked ugly to me. If that is preferred, though, I'm happy to do
it.

Thanks!

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
