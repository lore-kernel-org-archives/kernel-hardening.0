References: <20170603113007.GA1544@grsecurity.net>
 <1496498027.22395.1.camel@gmail.com> <20170603142110.GA7578@grsecurity.net>
 <CA+DvKQ+1BRVgWRcg_anBdf-8cV4=mgu8J9Kf1xVcbZBVePHSsw@mail.gmail.com>
 <20170604124900.GA7153@grsecurity.net>
From: Hector Martin <marcan@marcan.st>
Message-ID: <a485c07b-459b-0f6f-4dd9-4ddcf9d21086@marcan.st>
Date: Sun, 4 Jun 2017 22:48:48 +0900
MIME-Version: 1.0
In-Reply-To: <20170604124900.GA7153@grsecurity.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Stop the plagiarism
To: Brad Spengler <spender@grsecurity.net>, Daniel Micay <danielmicay@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, pageexec@freemail.hu
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-06-04 21:49, Brad Spengler wrote:
> Instead of replying to
> or acknowledging my initial simple mail, you went on IRC to joke about
> it publicly with other people.

It's somewhat ironic that someone who repeatedly complains about his
limited amount of time precluding upstreaming work somehow finds time to
stealth-idle on IRC channels to find out when people are talking about him.

Brad, you've been setting yourself up for everything going on. Of course
if you make it as hard as possible for people to upstream your work,
people will make mistakes. Of course if you make it as hard as possible
for people to tease coherent authorship information from your monolithic
patch, people will have no clue who actually wrote the code. Of course
if you start blocking people randomly on Twitter, people will troll you
to see if they get blocked.

We're all grateful for your contributions to Linux security, but
grsecurity has gotten as far as it has in spite of your attitude, not
because of it. You took your toys and went home (or "passed the baton"
as you put it) and the community is doing exactly what you'd expect them
to: try to make as much sense of what you left them and stop relying on you.

"A single file containing all 16 years of history" is exactly what
everyone else uses. We have Git for a reason. Your choice not to open up
your development process is yours and yours alone, but it comes with
consequences. You can't deliberately make everyone else's life as hard
as possible and then complain that they aren't doing their "due
diligence". You can't pull down all your historical patchsets and the
expect people to piece together the attribution information from cached
sources or mirrors. I'm sure any legitimate mistakes you point out will
be fixed. Or you could, you know, actually make people's life easier.

As much as it may sound unbelievable to you, yes, some of the stuff in
grsecurity is actually trivial, and it's entirely reasonable for someone
else to have come up with materially the same solution independently.
You can't copyright an integer constant. There is little point in
arguing over copyright on whole-tree cleanup work; things like
converting to designated initializers aren't even, in my opinion
(IANAL), clear-cut copyrightable changes. And you can't copyright ideas,
so if someone reimplements a grsecurity feature without copying any of
the code, that's entirely fair game copyright-wise.

Honestly, I'm not entirely sure why I'm writing this, because with moves
like the GCC plugin licensing shenanigans and the general licensing
approach for grsecurity you've demonstrated that you're not above using
ridiculous (and in my opinion license-violating) legal contortions to
try to exert further control over usage of your software than the GPLv2
allows; software which wouldn't exist were it not for the upstream
codebase it's based on, and GPLed contributions from many others. But,
and recognizing the chances of you giving a damn are slim at this point,
I ask: can you please decide whether you're going to help the community
with this endeavor, or whether you're going to sit back and let people
figure things out the best they can? You can't have it both ways. Either
get involved in a positive manner, or please stop obstructing everyone
else's work. Throwing around the L-word is, at best, going to make
people dislike your approach even more, and, at worst, actively stifle
the improvement of Linux security.

P.S. I had to reboot my router a few months ago, so I no longer have the
old IP address that you had blocked from your web server. Feel free to
remove that iptables rule now and shave a microsecond or two off your
packet processing time.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
