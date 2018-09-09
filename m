MIME-Version: 1.0
In-Reply-To: <20180909165647.GC22251@thunk.org>
References: <CACXcFmki+t-TvaiYxfOyphkF+LRQcJHFQjgW31HrYGRhOCYrEg@mail.gmail.com>
 <20180909125912.GA17863@kroah.com> <20180909165647.GC22251@thunk.org>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sun, 9 Sep 2018 14:24:13 -0400
Message-ID: <CAFUG7CeV6wTe7_7ZXcB7FCP5+O3-x41hDRAbSO12vw=O2DJ0AQ@mail.gmail.com>
Subject: Re: Checked C?
Content-Type: text/plain; charset="UTF-8"
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Greg KH <greg@kroah.com>, Sandy Harris <sandyinchina@gmail.com>, kernel-hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quick glance over the paper describes type and bounds checks
attempting to make access safer at compile and runtime via new
syntax... The caveat of "The safety provided by checked pointers can
be thwarted by unsafe operations, such as writes to traditional
pointers" leads to some immediate coverage concerns.
Doesn't grsecurity/PaX already do things like this with GCC plugins?
My understanding is that analogous functionality is available with
GCC, and wouldn't require adopting MSFT's take on "how C should be" in
Linux.
If the kernel is to move to Clang (which seems to be a direction which
Google and others are going), then implementing LLVM passes to do such
things may not require explicit syntax to declare these pointers, but
more likely exceptions to default use of safe types.

-Boris

On Sun, Sep 9, 2018 at 12:56 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> On Sun, Sep 09, 2018 at 02:59:12PM +0200, Greg KH wrote:
>> On Sun, Sep 09, 2018 at 08:22:44AM -0400, Sandy Harris wrote:
>> > Slashdot reports that Microsoft have come up with something they call
>> > "checked C". It claims to prevent a wide variety of memory & pointer
>> > bugs, using a mix of compile-time and run-time checks, at moderate
>> > overheads.
>> >
>> > Implementation is as extensions to Clang so it might be hard to apply
>> > to the kernel which I think has some GNU-isms. Perhaps still worth a
>> > look?
>
> What would be really interesting would be implementing the Microsoft
> extensions as Clang plugins, so the kernel changes don't require
> distributions to ship a modified Clang.
>
> Whoever does this will need to remember that kernel modifications need
> to work with:
>
>    * Clang with the extensions
>
>    * Clang without the extensions (in case the extensions are Clang
>      version dependent, and the system has a Clang which is too old).
>
>    * Gcc without the extensions
>
> We've been doing that sort of thing already, using CPP magic, so there
> are plenty of examples about ways of doing that.
>
>                                         - Ted



-- 
Boris Lukashev
Systems Architect
Semper Victus
