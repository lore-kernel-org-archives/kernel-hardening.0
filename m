Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <567317E1.9050000@labbott.name>
References: <5671B170.1090508@labbott.name>
	<CAGXu5jKKWAVn3Uzjk9n=+GKbPN8hN6Cys_QZQpRc8=AvZWV85Q@mail.gmail.com>
	<567317E1.9050000@labbott.name>
Date: Thu, 17 Dec 2015 12:27:30 -0800
Message-ID: <CAGXu5j+avLrj9sJLM5YGDsE-e0FZYdX_8PW9Xt_J4irK3pBYbg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking at PAX_MEMORY_SANITIZE
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 17, 2015 at 12:15 PM, Laura Abbott <laura@labbott.name> wrote:
> On 12/16/15 5:29 PM, Kees Cook wrote:
>>
>>
>>
>> On Wed, Dec 16, 2015 at 10:46 AM, Laura Abbott <laura@labbott.name
>> <mailto:laura@labbott.name>> wrote:
>>
>>     Hi,
>>
>>     I started looking at PAX_MEMORY_SANITIZE for bringing into the kernel.
>> I thought
>>     I would give a short update on what I've found so far for feedback and
>> the like.
>>
>>     PAX_MEMORY_SANITIZE is used for clearing both the SL*B allocators and
>> the
>>     buddy allocator on free. Arguably, similar behavior exists already as
>> debug
>>     features (SLUB_DEBUG poison, DEBUG_PAGEALLOC for some arches). Given
>> what we're
>>     already finding with features like DEBUG_RODATA though, the
>> sanitization really
>>     needs to be a separate Kconfig not tied to debugging. I debated trying
>> to make
>>     those Kconfigs non-debug but they were tied to other features besides
>> poison/
>>     sanitization.
>>
>>
>> Sounds great! As for CONFIGs, one thing that was request was that we
>> ultimately put all
>> the hardening configs under a common Kconfig heading so they can be found
>> easily. I view
>> this as a late-stage tweak, and mostly we just need to worry about
>> functionality first.
>>
>
> Sure. I was going to put the Kconfig somewhere I think is reasonable and see
> if
> there are better suggestions.
>
>> For upstreaming, we'll need a comparison between PAX_MEMORY_SANITIZE and
>> the existing
>> upstream things that overlap with it.
>
>
> What kind of comparison are you thinking of? Just a list of what differs
> featurewise
> or performance characteristics or something else?

Yeah, I meant features, but I'm sure we'll need to produce performance
details too.

>
>>
>>     I've been focusing my efforts on the SL*B allocators. As it stands,
>> the feature
>>     is fairly self-contained and mostly just needs some refactoring. I
>> plan on
>>     expanding the command line option to give a bit more control on where
>> the
>>     sanitization happens. The sanitization currently always happens on the
>> fast path
>>     so my thought was to allow the option of sanitizing only on the slow
>> path.
>>
>>
>> Seems like it should happen on all paths to be a true always-on hardening
>> feature, though?
>
>
> The existing PaX code has an option to skip caches marked with
> SLAB_NO_SANITIZE.
> I was thinking skipping on the fast path might be a similar expansion of
> that.
> There is still a boot commandline option for full sanitization.
>
> I'm going to profile before I send anything out to get a better idea if this
> option would make a difference.
>
>>
>>     The existing PaX code also disables cache merging. It's not clear if
>> this is an
>>     additional security measure but the sanitization as written doesn't
>> work with
>>     merging. For at least the first version, slab merging will be disabled
>> when
>>     sanitization is enabled on a slab.
>>
>>
>> That seems fine to me. These trade-offs are to be expected.
>>
>> Another thing we should call attention to are past bugs and exploits or
>> exploit methods
>> that would have been hampered or eliminated with this feature. e.g. How
>> does this
>> play with classic use-after-free, etc?
>
>
> Good point. I'll find some examples.
>
>>
>>     I'm hoping to post actual patches before I go on vacation for the
>> holidays next
>>     week. Early feedback is appreciated as well if I missed anything.
>>
>>
>> Fantastic! I look forward to testing it. Which gets to a third piece:
>> adding an lkdtm
>> test for the feature so it's easy to test the kernel's reaction to the
>> state that is
>> being protected.
>
>
> I'll look into this as well.
>
> Thanks,
> Laura

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
