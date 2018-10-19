From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] seq_buf: Make seq_buf_puts() NULL terminate the buffer
In-Reply-To: <CAG48ez2W8HeJcuPwA25vSqTco3B=CRzycSA0=--pG=7jWi3pPw@mail.gmail.com>
References: <20181017121000.30240-1-mpe@ellerman.id.au> <CAG48ez2W8HeJcuPwA25vSqTco3B=CRzycSA0=--pG=7jWi3pPw@mail.gmail.com>
Date: Fri, 19 Oct 2018 15:17:48 +1100
Message-ID: <87sh12vac3.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: Jann Horn <jannh@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Jann Horn <jannh@google.com> writes:
> On Wed, Oct 17, 2018 at 2:10 PM Michael Ellerman <mpe@ellerman.id.au> wro=
te:
>> Currently seq_buf_puts() will happily create a non NULL terminated
>> string for you in the buffer. This is particularly dangerous if the
>> buffer is on the stack.
>>
>> For example:
>>
>>   char buf[8];
>>   char secret =3D "secret";
>>   struct seq_buf s;
>>
>>   seq_buf_init(&s, buf, sizeof(buf));
>>   seq_buf_puts(&s, "foo");
>>   printk("Message is %s\n", buf);
>>
>> Can result in:
>>
>>   Message is foo=C2=AA=C2=AA=C2=AA=C2=AA=C2=AAsecret
>>
>> We could require all users to memset() their buffer to NULL before
>> use. But that seems likely to be forgotten and lead to bugs.
>>
>> Instead we can change seq_buf_puts() to always leave the buffer in a
>> NULL terminated state.
>>
>> The only downside is that this makes the buffer 1 character smaller
>> for seq_buf_puts(), but that seems like a good trade off.
>
> After this, you can also simplify rdt_last_cmd_status_show(), right?

Yes.

We also have a seq_buf_printf() in powerpc code that is printing a fixed
string purely to get NULL termination, so that can become a
seq_buf_puts().

>> diff --git a/lib/seq_buf.c b/lib/seq_buf.c
>> index 11f2ae0f9099..b1570204cde3 100644
>> --- a/lib/seq_buf.c
>> +++ b/lib/seq_buf.c
>> @@ -144,9 +144,13 @@ int seq_buf_puts(struct seq_buf *s, const char *str)
>>
>>         WARN_ON(s->size =3D=3D 0);
>>
>> +       /* Add 1 to len for the trailing NULL which must be there */
>
> Nit: In the comments, I would prefer either "null byte" or "NUL"
> instead of "NULL" when talking about something that is not a pointer.

Hmm yeah I guess. I think of them as being more or less the same thing,
or at least interchangeable, but that's a bit sloppy.

I'll send a v2 with "null byte".

>> +       len +=3D 1;
>
> It looks like you're using an "unsigned int" for the length, meaning
> that this can in theory (e.g. when operating on a string from a big
> vmalloc buffer) overflow. You should be using size_t here.

Yes you're right.

And if len overflows to zero above ..

>>         if (seq_buf_can_fit(s, len)) {

This will return true.

>>                 memcpy(s->buffer + s->len, str, len);
>> -               s->len +=3D len;
>> +               /* Don't count the trailing NULL against the capacity */
>> +               s->len +=3D len - 1;

And then here s->len becomes UINT_MAX.

I think. Which is probably not what we want.

I'll send a patch to switch to size_t in there.

cheers
