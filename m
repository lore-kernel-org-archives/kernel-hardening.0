Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 7 Oct 2016 17:40:08 +0200
From: David Sterba <dave@jikos.cz>
Message-ID: <20161007154008.GB15400@twin.jikos.cz>
References: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462468869-6210-1-git-send-email-michael.leibowitz@intel.com>
Subject: Re: [kernel-hardening] [RFC 0/3] Add struct randomization plugin
To: kernel-hardening@lists.openwall.com
Cc: spender@grsecurity.net, keescook@chromium.org, re.emese@gmail.com, pageexec@freemail.hu, michael.leibowitz@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Thu, May 05, 2016 at 10:21:06AM -0700, Michael Leibowitz wrote:
> This patch set ports over grsecurity's structure randomization
> feature.  The plugin is largely unchanged from grsecurity, with some
> porting to go over Emese Revfy's v7 patch set for gcc plugin
> infrastructure.  This is an RFC.
> 
> Although this set of changes does not directly make exploitation
> harder, when a number of structures are randomized, it will make it
> difficult to splat many relevant structures without knowing the exact
> build of the kernel the target is using.  While for one structure,
> there are limited number of guesses required, in aggregate, this can
> be a large obstacle for exploitation.
> 
> Patch 3 is a grab bag that probably needs to be broken up, although
> I'm not sure of the best way to do so.  Breaking by subsystem would
> seem to make an unwieldy patch set.
> 
> Known TODO that is not addressed as part of this patch set:
>   * tag security relevant structures for randomization
>   * add checkpatch checking for non-C99 initialization
>   * automated testing of randomization
>   * better description and examples of exploits effectively mitigated
>     by this feature
> 
> Tagging of structures to be randomized will come in subsequent series
> of patches.

may I ask what's the status of this patchset? As 4.8 now contains the
plugin infrastructure, which I really like to see happening, we could
add the remaining plugins. I'm specifically interested in the struct
layout randomization.

In your initial RFC, the patch 3/3 touches a lot of subsystems, which
means potentially dealing with many maintainers. As the patch is a
prerequsite for unmodified randstrcut plugin, I think this would stall
the inclusion for a long time.

The plugin detects "structs with function pointers only" and
automatically adds the randomization. I suggest to start without this
particular feature, and avoid dependency on patch 3/3.

Only the explicit randomize_layout attributes would actually do
something. That way the patches could be submitted separately, with it's
own reasoning. See the grsecruity patch for examples.

This is not perfect compared to the full featured plugin but I think the
proposed way is better than waiting until all issues from patch 3/3 are
fixed.

I'm willing to help and push things forward, but as you've submitted the
patches I'm asking first.
