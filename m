MIME-Version: 1.0
In-Reply-To: <CAGXu5jJBmKiDnhV26kEZyCf+TGWnpMOvSjiYaUr1U6z0FLPJHg@mail.gmail.com>
References: <CAAGnT3YJGf=eixt2+O_XsHiJZFP+CSO9A0a4qc-NKHRf=4y0sw@mail.gmail.com>
 <CAGXu5jJBmKiDnhV26kEZyCf+TGWnpMOvSjiYaUr1U6z0FLPJHg@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 13 Feb 2018 11:38:08 +0000
Message-ID: <CAKv+Gu_SxHCekoCoOFTOLFbN0besY+BRj+AzUYk88xK=zsZKBg@mail.gmail.com>
Subject: Re: Hello world! Student interested in getting involved.
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Ahmed Soliman <ahmedsoliman0x666@gmail.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 12 February 2018 at 23:01, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Feb 10, 2018 at 11:18 AM, Ahmed Soliman
> <ahmedsoliman0x666@gmail.com> wrote:
>> I am student, currently studying computer and communication engineering, My
>> relevant academic background is undergraduate level courses in operating
>> systems, system software, compiler theory, architecture, microprocessors.
>> Well most of which are outdated stuff anyway but I have some ideas. My real
>
> Welcome to the list!
>
>> background comes from Playing CTFs in my free time (which is basically 24/7)
>> doing mainly Reverse engineering and Binary exploitation, I have done 2~3
>> hello world kernel exploit dev for learning. so I have the basic knowledge,
>
> Excellent; CTFs can be extremely educational. There aren't enough
> kernel CTFs, IMO. :)
>
>> And I use hand tweaked Gentoo! I have 1 documentation kernel patch \o/.
>
> Hey, that's a good place to start! What was fixed?
>
>> I am exploiting the fact that we shall be doing Software Engineering course
>> This semester, so to enforce myself to get started developing for the
>> kernel, I was guided here though long searching journey with #kernelnewbies
>> and approaching many couple of maintainers in general.
>>
>> I always experienced people asking me even on kernelnewbies why I want to
>> write stuff for kernel, well it is just for pure fun and I like doing almost
>> low level security. And low level security requires being aware with kernel.
>> Please just don't try to send me off. And I hope no one gets the wrong idea
>> that I am only doing this for school.
>
> You've got the primary element: desire to work on it. :) There aren't
> a lot of people interested in low level code, and even fewer
> interested in security, so we'd love to help however we can.
>
>> Anyway I am interested in this implementing KASLR for ARM, I just wanted to
>> make sure that no one is working on that because this is major school
>> requirement, we are assumed to deliver a self contained "something" that
>> isn't ours and not someone's else.
>
> Ard (now on CC) implemented a first-pass at this already, but it
> likely needs some more tweaking and running down of any loose ends.
>
> See here:
> http://www.openwall.com/lists/kernel-hardening/2017/08/14/2
>
>> The reason I chose this one is that I think that is the only one that I
>> understand (in a very abstract level) among all of them. so it should be the
>> easiest way to kick start in my opinion.
>> Assuming that I am right, I wanted to state that the only ARM32 hardware I
>> own is raspberry pi zero, and Qemu of course, should that be enough please
>> do let me know, and I would appreciate any reading materials provided I am
>> already reading through wiki but there could be hidden gems that I missed.
>
> I'll let Ard take over; but between Qemu and real hardware you should
> be set. One of the tricky parts of arm32 is how many earlier CPU types
> there were, which can make some aspects more difficult to test. In the
> worst case, you can just mark it as available on certain hardware.
>

The latest version of my kaslr branch is feature complete, but I get
some hard to diagnose boot errors in automated boot testing on
kernelci.org

However, over the past few months I did not get a single query from
anyone about how the work was progressing, and KASLR is a rather
intrusive change, so I am reluctant to spend time and/or endorse
others doing so for a feature that will require a substantial
maintenance effort without any real benefit to anyone.
