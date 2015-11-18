Reply-To: kernel-hardening@lists.openwall.com
References: <CAGXu5jLE7ADT90-o-6xRA+1NGXtF3fuPnEcY2Qh6MQxaiWrHWw@mail.gmail.com>
 <56463FE5.1050500@redhat.com>
 <CAGXu5jLi=YsZNO4osWjqrJ_jLE3AQMmEKDGBCAJD7svn69Afew@mail.gmail.com>
From: Jeff Law <law@redhat.com>
Message-ID: <564D04CC.9090902@redhat.com>
Date: Wed, 18 Nov 2015 16:07:56 -0700
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLi=YsZNO4osWjqrJ_jLE3AQMmEKDGBCAJD7svn69Afew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: GCC upstream contacts for Linux kernel bugs
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@google.com>, Richard Henderson <rth@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees asked me to bring this discussion over to the list...  So here we go...

On 11/13/2015 03:27 PM, Kees Cook wrote:
>>
>> The discussion had a reference to a GCC issue without any real details
>> (intentional overflow).  From what I read, I suspect the culprit is the
>> early folding that's done by the front-ends.
>
> Yeah, that's one of the things that got mentioned.
>
>> We're currently in the process of trying to defer folding until the
>> transition from front-end tree/generic to gimple.  We're starting with C++
>> because delayed folding is essentially a requirement for proper
>> implementation of certain language features.  C support ought to be
>> relatively easy once we've got the C++ front-end bits in place.
>
> I would be forever grateful if you could join the list and comment on
> this progress. I think a lot of people would be very glad to see some
> mention of the plans here.
It's certainly recognized that the folding done by the front-ends has 
significant disadvantages for a variety of use cases.

The most important one for this discussion is it's impossible for code 
outside the front-end to see expressions in a form that is reasonably 
close, if not the same as what appeared in the input source.

So the natural solution is to delay folding of expressions until a later 
point in the compilation pipeline.  Ideally until we hit the 
generic/gimple barrier.  We also want to delay canonicalization, 
reassociation and other transformations that hide the original structure 
of expressions.

The initial focus of that work is for the C++ front-end (where it's 
needed to implement certain language features correctly).  I haven't 
checked if the original form survives until a point where a plugin could 
examine the original form.  The work isn't terribly deep or complex, but 
tedious as most diagnostics require folded expressions.  Delayed folding 
isn't a strict language requirement for C, so we haven't invested any 
effort yet into replicating the work in the C front-end.

It's also still the case that things like operand shortening and some 
canonicalizations still occur -- they're in a different part of the 
compiler.  There's a plan and a fair amount of code to defer those 
operations, but it didn't land in time for the upcoming GCC 6 release.




>
>> The best way forward will be to get a bug report filed.  That allows
>> tracking the issue, helps with resource juggling and ultimately reaches a
>> wider audience.
>
> If you can, I'd love to see what you think about the existing open
> bugs (at the corrected URL above). I'm much less familiar with these
> internals, so talking on the list or in the bugs would be fantastic --
> or aiming me at someone else I should pester. :)
>
> Thanks for the reply! I think at the very least, we can provide you
> with some immediate feedback on some of these features. :)
41757 is already fixed.  It is highly unlikely that it would be 
backported to 4.5/4.6 era compilers -- we've stopped working on those 
vintage compilers.  I've closed this report.

46354 I don't really have any state here.  I try pretty hard never to 
look at the structure/type layout code.  It's amazingly complex and easy 
to get wrong.  The BZ text implies that the kernel is relying on this 
behaviour, so one possible outcome is current behaviour gets documented 
and set it in stone.  Unfortunately the guy I'd like to pass this off to 
just disappeared on extended PTO :(

61311 anything in the streaming space is primarily handled by the SuSE 
guys.  However, in terms of header files, my recollection is that 
there's supposed to be an aggregator for plugins so that they're 
isolated from the header file restructuring that's going on.  I haven't 
actually tried it though.

61313 this was supposed to fix some problem with plugins on cross 
targets.  Apparently something went wrong.  It looks like there's a bad 
interaction with collect2.  I've alerted the original author of the 
offending change.

jeff
