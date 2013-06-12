ProposalListCtrl =
  ($scope, $routeParams, $location, proposals, SessionSettings, SpokenvoteCookies, VotingService) ->
    $scope.proposals = proposals
    $scope.filterSelection = $routeParams.filter
    $scope.spokenvoteSession = SpokenvoteCookies

    $scope.setFilter = (filterSelected) ->
      $location.search('filter', filterSelected)

    $scope.$on 'event:proposalsChanged', ->
      $scope.proposals.$query
      console.log $scope.proposals

    $scope.new = ->
      if $scope.sessionSettings.hub_attributes.id?
        $scope.sessionSettings.actions.changeHub = false
      else
        $scope.sessionSettings.actions.changeHub = true
      VotingService.new $scope

ProposalShowCtrl = ( $scope, $location, AlertService, proposal, SessionSettings, VotingService ) ->
  $scope.proposal = proposal

  $scope.$on 'event:votesChanged', ->
    $scope.proposal.$get()

  $scope.support = ( clicked_proposal_id ) ->
    VotingService.support $scope, clicked_proposal_id

  $scope.improve = ( clicked_proposal_id ) ->
    VotingService.improve $scope, clicked_proposal_id


RelatedProposalShowCtrl =
  ($scope, $location, AlertService, SessionSettings, VotingService, RelatedProposalsLoader) ->
    $scope.selectedSort = $location.search().related_sort_by

    $scope.$on 'event:votesChanged', ->
      $scope.relatedProposals.$get()

    $scope.relatedProposals =
      RelatedProposalsLoader().then (relatedProposals) ->
        relatedProposals

    $scope.related_sorter_dropdown = [
      text: "By Votes"
      submenu: [
        text: "Most Votes"
        click: "sortRelatedProposals('Most Votes')"
      ,
        text: "Least Votes"
        click: "sortRelatedProposals('Least Votes')"
      ]
    ,
      text: "By Age"
      submenu: [
        text: "Most Recently Voted on"
        click: "sortRelatedProposals('Most Recently Voted on')"
      ,
        text: "Oldest Most Recent Vote"
        click: "sortRelatedProposals('Oldest Most Recent Vote')"
      ]
    ]

    $scope.sortRelatedProposals = (related_sort_by) ->
      $location.search('related_sort_by', related_sort_by)
      $scope.selectedSort = related_sort_by

# Injects
ProposalListCtrl.$inject = [ '$scope', '$routeParams', '$location', 'proposals', 'SessionSettings', 'SpokenvoteCookies', 'VotingService' ]
ProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'proposal', 'SessionSettings', 'VotingService' ]
RelatedProposalShowCtrl.$inject = [ '$scope', '$location', 'AlertService', 'SessionSettings', 'VotingService', 'RelatedProposalsLoader' ]

# Register
App.controller 'ProposalListCtrl', ProposalListCtrl
App.controller 'ProposalShowCtrl', ProposalShowCtrl
App.controller 'RelatedProposalShowCtrl', RelatedProposalShowCtrl
