MIME-Version: 1.0
In-Reply-To: <CAEk6tEzs9_UMVQJrvQtXgVhLMVo0Hb9QEB3_dX2JtpRsu0hM0g@mail.gmail.com>
References: <CAEk6tEzVh3=6QbvcjOUz6ESdA8JzFD4dagTFiKdguegtoquJXg@mail.gmail.com>
 <CAJcbSZHRo-sGVcMVBkXJRdRJHyv9_8g9RHYuy8wfo8m2gRhnDw@mail.gmail.com>
 <CAEk6tEz5XqKOytCSCYj3TfpXZDKSBS6aam-O1Aqp0Oz7-_RgNw@mail.gmail.com>
 <871svfytb0.fsf@xmission.com> <CAEk6tEw5-19rZFHL2+-uw+sibegb1KAQj24jk8YZz3m_KE7TKw@mail.gmail.com>
 <20170203204842.GF7330@bananaboat.hashbangbash.com> <CAEk6tEzs9_UMVQJrvQtXgVhLMVo0Hb9QEB3_dX2JtpRsu0hM0g@mail.gmail.com>
From: Jessica Frazelle <me@jessfraz.com>
Date: Mon, 6 Feb 2017 05:51:04 -0800
Message-ID: <CAEk6tEwNv359zqiMwSVvJbe0KGE4fTLyXz6R99i1Kh+6qUFFMg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Container Hardening
To: Vincent Batts <vbatts@hashbangbash.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

As far as a list of CVEs I forgot I had already made one[1]. A lot of
those are considered "non-events" due to the fact the default seccomp
profile for docker containers blocks them. It outlines as far as the
mitigation.

Another that should probably be added there, that was not blocked by
the default seccomp profile was Dirty cow.


[1] https://github.com/jessfraz/docker/blob/6837cfc13cba842186a7261aa9bbd3a8755fd11e/docs/security/non-events.md

On Fri, Feb 3, 2017 at 1:13 PM, Jessica Frazelle <me@jessfraz.com> wrote:
> Thanks, I'll check it out.
>
> On Fri, Feb 3, 2017 at 12:48 PM Vincent Batts <vbatts@hashbangbash.com>
> wrote:
>>
>> Jess,
>>
>> In the vein of your proposal
>> (https://gist.github.com/jessfraz/3a84023ff85471696ee33a20031b9e7b),
>> there was recently a systemtap (http://sourceware.org/systemtap/) script
>> written to output some of this data that is not generally accessible
>> from userspace.
>>
>> Will Cohen was nice enough to upload this and a quick write-up on it's
>> usage.
>>
>> https://github.com/wcohen/linux-instrumentation/blob/master/container_check.md
>>
>> Where this can show when a "badcap" is encountered, or just to see the
>> profile of capabilities and syscalls used.
>>
>> vb
>>
>>
>



-- 


Jessie Frazelle
4096R / D4C4 DD60 0D66 F65A 8EFC  511E 18F3 685C 0022 BFF3
pgp.mit.edu
