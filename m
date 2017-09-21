References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <9ca0ef74-b409-2eae-07f8-9fd7d83989a5@intel.com>
Date: Wed, 20 Sep 2017 17:28:11 -0700
MIME-Version: 1.0
In-Reply-To: <20170907173609.22696-4-tycho@docker.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Tycho Andersen <tycho@docker.com>, linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

At a high level, does this approach keep an attacker from being able to
determine the address of data in the linear map, or does it keep them
from being able to *exploit* it?  Can you have a ret2dir attack if the
attacker doesn't know the address, for instance?
