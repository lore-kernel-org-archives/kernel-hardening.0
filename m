MIME-Version: 1.0
In-Reply-To: <d1ffc1cd48b545ebb81a7f682fde9f1d@AcuMS.aculab.com>
References: <1511337706-8297-1-git-send-email-s.mesoraca16@gmail.com>
 <1511337706-8297-3-git-send-email-s.mesoraca16@gmail.com> <20171122165144.07aea7ac@alans-desktop>
 <33dcc007e92349999ce77bf45825be22@AcuMS.aculab.com> <CAJHCu1K-xZXaXh38qYaNzJBr+USVxvsaqOReZjtnchxVOyYnww@mail.gmail.com>
 <d1ffc1cd48b545ebb81a7f682fde9f1d@AcuMS.aculab.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Sun, 26 Nov 2017 12:29:35 +0100
Message-ID: <CAJHCu1J+=hFUZn2WsA0x-Y75Gu3Jtb8DYAf=LVu=B8nfCX_=_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v3 2/2] Protected O_CREAT open in sticky directories
To: David Laight <David.Laight@aculab.com>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

2017-11-24 12:53 GMT+01:00 David Laight <David.Laight@aculab.com>:
> From: Salvatore Mesoraca [mailto:s.mesoraca16@gmail.com]
>> Sent: 24 November 2017 11:44
>>
>> 2017-11-24 11:53 GMT+01:00 David Laight <David.Laight@aculab.com>:
>> > From: Alan Cox
>> >> Sent: 22 November 2017 16:52
>> >>
>> >> On Wed, 22 Nov 2017 09:01:46 +0100
>> >> Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
>> >>
>> >> > Disallows O_CREAT open missing the O_EXCL flag, in world or
>> >> > group writable directories, even if the file doesn't exist yet.
>> >> > With few exceptions (e.g. shared lock files based on flock())
>> >>
>> >> Enough exceptions to make it a bad idea.
>> >>
>> >> Firstly if you care this much *stop* having shared writable directories.
>> >> We have namespaces, you don't need them. You can give every user their
>> >> own /tmp etc.
>> >
>> > Looks like a very bad idea to me as well.
>> >
>> > Doesn't this stop all shell redirects into a shared /tmp ?
>> > I'm pretty sure most programs use O_CREAT | O_TRUNC for output
>> > files - they'll all stop working.
>>
>> If some program does such a thing, that's a potential vulnerability.
>> With "protected_hardlinks" you are, in most cases, safe.
>> But, still, that program has a bug and having this feature enabled will
>> help you notice it soon.
>> For that matter, I'm using this patch on my system and I don't have any
>> program behaving like this.
>
> Hmmm.... a quick strace shows cp and vi doing stat("/tmp/foo") and then
> open(O_WRONLY|O_TRUNC) if it exists and O_CREATE|O_EXCL if it doesn't.
> I can't help feeling that is just hiding a race.

Yes, unfortunately, doing something like "cp somefile /tmp/" is a bad
practice that
in most cases will go unnoticed by this feature. Nevertheless there
are many other
real world vulnerability that it would have been able to detect.
Thank you very much for taking the time to do some experiments.

Salvatore
