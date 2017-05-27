Date: Sat, 27 May 2017 01:47:48 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170527084748.GA11558@infradead.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
 <1495829844-69341-15-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495829844-69341-15-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH v2 14/20] drm/amd/powerplay: Use designated initializers
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Eric Huang <JinHuiEric.Huang@amd.com>, Alex Deucher <alexander.deucher@amd.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

> +	{ .isFunctionNeededInRuntimeTable = NULL,
> +	  .tableFunction = tf_vega10_thermal_initialize },

I'd say drop the NULL initializations as they are implicit anyway.
